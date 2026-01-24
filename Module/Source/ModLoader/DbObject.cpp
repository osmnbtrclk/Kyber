// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#include <Base/Pch.h>

#include <Core/Program.h>
#include <ModLoader/DbObject.h>

#include <ByteBuffer/ByteBuffer.hpp>

#include <memory>

namespace Kyber
{
int read7BitEncodedInt(bb::ByteBuffer& buf)
{
    int result = 0;
    int i = 0;

    while (true)
    {
        int b = buf.get();
        result |= (b & 127) << i;

        if (b >> 7 == 0)
        {
            return result;
        }

        i += 7;
    }
}

long read7BitEncodedLong(bb::ByteBuffer& buf)
{
    long result = 0;
    int i = 0;

    while (true)
    {
        int b = buf.get();
        result |= (long)((b & 127) << i);

        if (b >> 7 == 0)
        {
            return result;
        }

        i += 7;
    }
}

void write7BitEncodedInt(bb::ByteBuffer& buf, uint32_t value)
{
    while (value >= 0x80)
    {
        buf.put((uint8_t)(value | 0x80));
        value >>= 7;
    }
    buf.put((uint8_t)value);
}

void write7BitEncodedLong(bb::ByteBuffer& buf, uint64_t value)
{
    while (value >= 0x80)
    {
        buf.put((uint8_t)(value | 0x80));
        value >>= 7;
    }
    buf.put((uint8_t)value);
}

std::shared_ptr<DbObject> DbObject::Load(bb::ByteBuffer& buf, std::string& outputName)
{
    uint8_t flags = buf.get();
    DbType type = static_cast<DbType>(flags & 0x1F);
    if (type == DbType_Invalid)
    {
        return nullptr;
    }

    if ((flags & 0x80) == 0)
    {
        outputName = buf.getNullTerminatedString();
    }

    switch (type)
    {
    case DbType_List: {
        long size = read7BitEncodedLong(buf);
        long offset = buf.getReadPos();

        std::vector<std::shared_ptr<DbObject>> values;
        while (buf.getReadPos() - offset < size)
        {
            std::string name;
            auto subValue = Load(buf, name);
            if (!subValue)
            {
                break;
            }

            values.push_back(std::move(subValue));
        }

        return std::make_shared<DbObject>(values);
    }
    case DbType_Object: {
        long size = read7BitEncodedLong(buf);
        long offset = buf.getReadPos();

        std::map<std::string, std::shared_ptr<DbObject>> values;
        while (buf.getReadPos() - offset < size)
        {
            std::string name;
            auto subValue = Load(buf, name);
            if (!subValue)
            {
                break;
            }

            values.emplace(name, std::move(subValue));
        }
        return std::make_shared<DbObject>(values);
    }
    case DbType_Boolean:
        return std::make_shared<DbObject>(buf.get() == 1);
    case DbType_String: {
        long size = read7BitEncodedInt(buf);
        char* data = new char[size + 1];
        buf.getBytes(reinterpret_cast<uint8_t*>(data), size);
        data[size] = '\0';
        auto obj = std::make_shared<DbObject>(std::string(data));
        delete[] data;
        return obj;
    }
    case DbType_Int:
        return std::make_shared<DbObject>(buf.getInt());
    case DbType_Long:
        return std::make_shared<DbObject>(buf.getLong());
    case DbType_Float:
        return std::make_shared<DbObject>(buf.getFloat());
    case DbType_Double:
        return std::make_shared<DbObject>(buf.getDouble());
    case DbType_Guid:
    case DbType_Sha1:
    case DbType_ByteArray:
        KB_UNIMPLEMENTED;
    default:
        return nullptr;
    }
}

std::vector<uint8_t> DbObject::Save(const std::string& name)
{
    bb::ByteBuffer buf;

    DbType objType = GetType();

    uint8_t dbFlags = (name.empty()) ? 0x80 : 0x00;
    buf.put(static_cast<uint8_t>(dbFlags | static_cast<uint8_t>(objType)));

    if (!(dbFlags & 0x80))
        buf.putNullTerminatedString(name.c_str());

    switch (objType) {
        case DbType_Boolean: {
            auto val = std::get<bool>(value);
            buf.put(static_cast<uint8_t>(val ? 0x01 : 0x00));
            break;
        }
        case DbType_String: {
            auto& str = std::get<std::string>(value);
            write7BitEncodedInt(buf, str.size());
            buf.putBytes(const_cast<uint8_t*>(reinterpret_cast<const uint8_t*>(str.data())), str.size());
            break;
        }
        case DbType_Int: {
            auto val = std::get<uint32_t>(value);
            buf.putInt(val);
            break;
        }
        case DbType_List: {
            auto& list = std::get<DbList>(value);
            bb::ByteBuffer subWriter;

            for (auto& item : list) {
                auto buffer = item->Save("");
                subWriter.putBytes(buffer.data(), buffer.size());
            }

            auto buffer = subWriter.getBuf();
            write7BitEncodedLong(buf, buffer.size() + 1);
            buf.putBytes(reinterpret_cast<uint8_t*>(buffer.data()), buffer.size());
            buf.put(static_cast<uint8_t>(0x00));
            break;
        }
        case DbType_Object: {
            auto& objMap = std::get<DbMap>(value);
            bb::ByteBuffer subWriter;

            for (auto& [key, val] : objMap) {
                auto buffer = val->Save(key);
                subWriter.putBytes(buffer.data(), buffer.size());
            }

            auto buffer = subWriter.getBuf();
            write7BitEncodedLong(buf, buffer.size() + 1);
            buf.putBytes(reinterpret_cast<uint8_t*>(buffer.data()), buffer.size());
            buf.put(static_cast<uint8_t>(0x00));
            break;
        }
        default:
            KB_UNIMPLEMENTED;
    }

    return buf.getBuf();
}

DbType DbObject::GetType() const
{
    return std::visit([](auto&& arg) -> DbType {
        using T = std::decay_t<decltype(arg)>;
        if constexpr (std::is_same_v<T, std::monostate>) return DbType_Invalid;
        else if constexpr (std::is_same_v<T, bool>) return DbType_Boolean;
        else if constexpr (std::is_same_v<T, uint32_t>) return DbType_Int;
        else if constexpr (std::is_same_v<T, uint64_t>) return DbType_Long;
        else if constexpr (std::is_same_v<T, float>) return DbType_Float;
        else if constexpr (std::is_same_v<T, double>) return DbType_Double;
        else if constexpr (std::is_same_v<T, std::string>) return DbType_String;
        else if constexpr (std::is_same_v<T, std::vector<uint8_t>>) return DbType_ByteArray;
        else if constexpr (std::is_same_v<T, Guid>) return DbType_Guid;
        else if constexpr (std::is_same_v<T, Sha1>) return DbType_Sha1;
        else if constexpr (std::is_same_v<T, DbList>) return DbType_List;
        else if constexpr (std::is_same_v<T, DbMap>) return DbType_Object;
    }, value);
}

std::string DbObject::ToString() const
{
    return std::visit(
        Overloaded{
            [](std::monostate) -> std::string { return "null"; },
            [](bool b) -> std::string { return b ? "true" : "false"; },
            [](uint32_t i) -> std::string { return "Int(" + std::to_string(i) + ")"; },
            [](uint64_t l) -> std::string { return "Long(" + std::to_string(l) + ")"; },
            [](float f) -> std::string { return "Float(" + std::to_string(f) + ")"; },
            [](double d) -> std::string { return "Double(" + std::to_string(d) + ")"; },
            [](const std::string& s) -> std::string { return "\"" + s + "\""; },
            [](const std::vector<uint8_t>& byteArray) -> std::string {
                std::stringstream ss;
                ss << "ByteArray[" << byteArray.size() << "]";
                return ss.str();
            },
            [](const Guid& guid) -> std::string {
                std::stringstream ss;
                ss << "Guid[" << guid.ToString() << "]";
                return ss.str();
            },
            [](const Sha1& sha1) -> std::string {
                std::stringstream ss;
                ss << "Sha1";
                return ss.str();
            },
            [](const DbList& list) -> std::string {
                std::stringstream ss;
                ss << "List[";
                for (size_t i = 0; i < list.size(); ++i)
                {
                    if (i > 0)
                        ss << ", ";
                    ss << list[i]->ToString();
                }
                ss << "]";
                return ss.str();
            },
            [](const DbMap& map) -> std::string {
                std::stringstream ss;
                ss << "Map{";
                bool first = true;
                for (const auto& [key, value] : map)
                {
                    if (!first)
                        ss << ", ";
                    first = false;
                    ss << "\"" << key << "\": " << value->ToString();
                }
                ss << "}";
                return ss.str();
            }
        },
        value);
}
} // namespace Kyber
