#pragma once

#include <SDK/TypeInfo.h>

#include <cstdint>
#include <memory>
#include <variant>

namespace Kyber
{
enum DbType
{
    DbType_Invalid = 0,
    DbType_List = 1,
    DbType_Object = 2,
    DbType_Boolean = 6,
    DbType_String = 7,
    DbType_Int = 8,
    DbType_Long = 9,
    DbType_Float = 11,
    DbType_Double = 12,
    DbType_Guid = 15,
    DbType_Sha1 = 16,
    DbType_ByteArray = 19
};

class DbObject;

using DbList = std::vector<std::shared_ptr<DbObject>>;
using DbMap = std::map<std::string, std::shared_ptr<DbObject>>;

using DbValue = std::variant<
    std::monostate,
    bool,
    uint32_t,
    uint64_t,
    float,
    double,
    std::string,
    std::vector<uint8_t>, // ByteArray
    Guid,
    Sha1,
    DbList,
    DbMap
>;

class DbObject
{
public:
    DbObject() = default;
    explicit DbObject(DbValue&& value) : value(std::move(value)) {}

    std::string ToString() const;

    const DbValue& GetValue() const {
        return value;
    }

    template<typename T>
    bool IsType() const {
        return std::holds_alternative<T>(value);
    }

    DbType GetType() const;

    template<typename T>
    T* Get() {
        return std::get_if<T>(&value);
    }

    template<typename T>
    const T* Get() const {
        return std::get_if<T>(&value);
    }

    static std::shared_ptr<DbObject> Load(bb::ByteBuffer& buf, std::string& outputName);
    std::vector<uint8_t> Save(const std::string& name);

private:
    // Helper type for visitor to handle all types in std::variant
    template<class... Ts> struct Overloaded : Ts... { using Ts::operator()...; };
    template<class... Ts> Overloaded(Ts...) -> Overloaded<Ts...>;
    
    DbValue value;
};
} // namespace Kyber
