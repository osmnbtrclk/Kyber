// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#include <Script/LuaDataContainer.h>
#include <Core/Program.h>
#include <Utilities/PlatformUtils.h>
#include <Script/Lua.h>
#include <SDK/Funcs.h>

namespace Kyber
{
const TypeInfo* typeInfo_DataContainer = (const TypeInfo*)0x1443F5020;

template<>
void LuaUtils::Push<DataContainer*>(lua_State* L, DataContainer* value)
{
    if (value == nullptr)
    {
        lua_pushnil(L);
        return;
    }

    LuaDataContainer::WrapDataContainer(L, value);
    luaL_getmetatable(L, "DataContainer");
    lua_setmetatable(L, -2);
}

template<>
void LuaUtils::Push<LuaValueTypeData>(lua_State* L, LuaValueTypeData value)
{
    if (value.value == nullptr)
    {
        lua_pushnil(L);
        return;
    }

    LuaDataContainer::WrapValueType(L, value.type, value.value);
    luaL_getmetatable(L, value.type->typeInfoData->name);
    lua_setmetatable(L, -2);
}

template<>
void LuaUtils::Push<TypeInfo*>(lua_State* L, TypeInfo* type)
{
    LuaDataContainer::WrapTypeInfo(L, type);
    luaL_getmetatable(L, "TypeInfo");
    lua_setmetatable(L, -2);
}

static int strcicmp(char const* a, char const* b)
{
    for (;; a++, b++)
    {
        int d = tolower((unsigned char)*a) - tolower((unsigned char)*b);
        if (d != 0 || !*a)
        {
            return d;
        }
    }
}

TypeInfo* LuaDataContainer::GetTypeInfo(lua_State* L, int index)
{
    if (!lua_isuserdata(L, index))
    {
        luaL_error(L, "Expected userdata for type info, got %s", lua_typename(L, lua_type(L, index)));
        return NULL;
    }

    TypeInfo** userdata = (TypeInfo**)lua_touserdata(L, index);
    if (userdata == NULL)
    {
        luaL_error(L, "Expected userdata for type info");
        return NULL;
    }

    return *userdata;
}

DataContainer* LuaDataContainer::GetDataContainer(lua_State* L, int index)
{
    if (!lua_isuserdata(L, index))
    {
        if (!lua_isnil(L, index))
        {
            luaL_error(L, "Expected userdata for container, got %s", lua_typename(L, lua_type(L, index)));
        }
        return NULL;
    }

    DataContainer** userdata = (DataContainer**)lua_touserdata(L, index);
    if (userdata == NULL)
    {
        luaL_error(L, "Expected userdata for container");
        return NULL;
    }

    return *userdata;
}

LuaValueTypeData* LuaDataContainer::GetValueType(lua_State* L, int index)
{
    if (!lua_isuserdata(L, index))
    {
        luaL_error(L, "Expected userdata for value type, got %s (idx: %d)", lua_typename(L, lua_type(L, index)), index);
        return NULL;
    }

    LuaValueTypeData* userdata = (LuaValueTypeData*)lua_touserdata(L, index);
    if (userdata == NULL)
    {
        luaL_error(L, "Expected userdata for value type");
        return NULL;
    }

    return userdata;
}

static int TypeInfoIndex(lua_State* L, void* value, FieldInfoData* field)
{
    void* target = reinterpret_cast<void*>(reinterpret_cast<__int64>(value) + field->fieldOffset);
    switch (field->fieldTypePtr->getBasicType())
    {
    case kTypeCode_Void:
    case kTypeCode_DbObject:
        break;
    case kTypeCode_ValueType: {
        KYBER_LOG(Debug, "Wrapping value type: " << std::hex << target);

        LuaDataContainer::WrapValueType(L, field->fieldTypePtr, target);
        luaL_getmetatable(L, field->fieldTypePtr->typeInfoData->name);
        lua_setmetatable(L, -2);
        break;
    }
    case kTypeCode_Class:
    case kTypeCode_Array:
        break;
    case kTypeCode_CString: {
        auto value = *reinterpret_cast<const char**>(target);
        if (value == nullptr)
        {
            return 0;
        }

        lua_pushstring(L, value);
        break;
    }
    case kTypeCode_Boolean:
        lua_pushboolean(L, *reinterpret_cast<bool*>(target));
        break;
    case kTypeCode_Int32:
        lua_pushinteger(L, *reinterpret_cast<int32_t*>(target));
        break;
    case kTypeCode_Uint32:
        lua_pushinteger(L, *reinterpret_cast<uint32_t*>(target));
        break;
    case kTypeCode_Float32:
        lua_pushnumber(L, *reinterpret_cast<float*>(target));
        break;
    case kTypeCode_Float64:
        break;
    default:
        KYBER_LOG(Warning, "Failed to get field: " << field->name << " at " << std::hex << target << " " << value << " "
                                                   << field->fieldTypePtr->getBasicType());
        return 0;
    }
    return 1;
}

static int TypeInfoNewIndex(lua_State* L, void* value, const FieldInfoData* field)
{
    void* target = reinterpret_cast<void*>(reinterpret_cast<__int64>(value) + field->fieldOffset);
    switch (field->fieldTypePtr->getBasicType())
    {
    case kTypeCode_Void:
    case kTypeCode_DbObject:
        break;
    case kTypeCode_ValueType:
        if (field->fieldTypePtr->typeInfoData->IsBlittable())
        {
            auto bind = LuaDataContainer::GetValueType(L, 3);
            if (bind->type != field->fieldTypePtr)
            {
                KYBER_LOG(Error, "Failed to set value type: " << field->fieldTypePtr->typeInfoData->name << ", type mismatch");
                return 0;
            }

            void* value = bind->value;
            KYBER_LOG(Debug, "Setting value type: " << field->fieldTypePtr->typeInfoData->name << " at " << std::hex << target << " "
                                                    << value << " " << std::dec << field->fieldOffset << " "
                                                    << bind->type->typeInfoData->name);
            memcpy(target, value, field->fieldTypePtr->typeInfoData->totalSize);
        }
        else
        {
            KYBER_LOG(Error, "Failed to set value type: " << field->fieldTypePtr->typeInfoData->name << ", not blittable");
        }
        break;
    case kTypeCode_Class: {
        DataContainer* current = *reinterpret_cast<DataContainer**>(target);
        if (current != nullptr)
        {
            // TODO release reference
        }

        DataContainer* container = LuaDataContainer::GetDataContainer(L, 3);
        if (container != nullptr)
        {
            container->addRef();
        }

        *reinterpret_cast<DataContainer**>(target) = container;
        break;
    }
    case kTypeCode_Array:
        break;
    case kTypeCode_Boolean: {
        *reinterpret_cast<bool*>(target) = lua_toboolean(L, 3);
        break;
    }
    case kTypeCode_CString: {
        const char* value = luaL_checkstring(L, 3);
        *reinterpret_cast<const char**>(target) = StringUtils::CopyWithArena(value);
        break;
    }
    case kTypeCode_Int32:
    case kTypeCode_Uint32: {
        uint32_t intValue = luaL_checkinteger(L, 3);
        *reinterpret_cast<uint32_t*>(target) = intValue;
        break;
    }
    case kTypeCode_Float32: {
        float floatValue = luaL_checknumber(L, 3);
        KYBER_LOG(Debug, "Setting float value: " << floatValue << " at " << std::hex << target << " " << value);
        *reinterpret_cast<float*>(target) = floatValue;
        break;
    }
    case kTypeCode_Float64:
        break;
    default:
        KYBER_LOG(Warning, "Failed to set field: " << field->name << " at " << std::hex << target << " " << value << " "
                                                   << field->fieldTypePtr->getBasicType());
        break;
    }
    return 0;
}

static FieldInfoData* FindField(ClassInfoData* infoData, const char* key)
{
    if (infoData == nullptr)
    {
        KYBER_LOG(Error, "Failed to find field: " << key << " in null class info");
        return nullptr;
    }

    FieldInfoData* fieldInfo = nullptr;
    for (int i = 0; i < infoData->fieldCount; i++)
    {
        FieldInfoData& field = infoData->fields[i];
        if (strcicmp(field.name, key) != 0)
        {
            continue;
        }

        fieldInfo = &field;
        break;
    }

    if (fieldInfo == nullptr && infoData->superClass != nullptr && infoData->superClass->typeInfoData != infoData)
    {
        fieldInfo = FindField((ClassInfoData*)infoData->superClass->typeInfoData, key);
    }

    if (fieldInfo == nullptr)
    {
        KYBER_LOG(Error, "Failed to find field: " << key << " in " << infoData->name);
    }

    return fieldInfo;
}

static int DataContainerIsFunc(lua_State* L)
{
    DataContainer* container = LuaDataContainer::GetDataContainer(L, 1);
    if (container == nullptr)
    {
        luaL_error(L, "DataContainer was null");
        return 0;
    }

    if (!lua_isstring(L, 2))
    {
        luaL_error(L, "Expected string for type comparison");
        return 0;
    }

    const char* key = luaL_checkstring(L, 2);
    const char* typeName = container->getType()->typeInfoData->name;

    lua_pushboolean(L, strcmp(key, typeName) == 0);
    return 1;
}

static int RawTypeInfoIndex(lua_State* L)
{
    TypeInfo* info = LuaDataContainer::GetTypeInfo(L, 1);
    std::string key = luaL_checkstring(L, 2);

    if (key == "name")
    {
        lua_pushstring(L, info->typeInfoData->name);
        return 1;
    }

    return 0;
}

static int DataContainerIndex(lua_State* L)
{
    DataContainer* container = LuaDataContainer::GetDataContainer(L, 1);
    const char* key = luaL_checkstring(L, 2);

    if (strcmp(key, "Is") == 0)
    {
        lua_pushcfunction(L, DataContainerIsFunc);
        return 1;
    }
    else if (strcmp(key, "typeInfo") == 0)
    {
        LuaUtils::Push(L, container->m_dcType);
        return 1;
    }

    FieldInfoData* fieldInfo = FindField((ClassInfoData*)container->m_dcType->typeInfoData, key);
    if (fieldInfo == nullptr)
    {
        KYBER_LOG(Error, "Failed to find field to create a property reader");
    nil:
        lua_pushnil(L);
        return 1;
    }

    int result = TypeInfoIndex(L, container, fieldInfo);
    if (result == 0)
    {
        goto nil;
    }

    return 1;
}

static int DataContainerNewIndex(lua_State* L)
{
    DataContainer* container = LuaDataContainer::GetDataContainer(L, 1);
    const char* key = luaL_checkstring(L, 2);

    FieldInfoData* fieldInfo = FindField((ClassInfoData*)container->m_dcType->typeInfoData, key);
    if (fieldInfo == nullptr)
    {
        KYBER_LOG(Error, "Failed to find field to create a property writer for " << key);
        return 0;
    }

    return TypeInfoNewIndex(L, container, fieldInfo);
}

static int ValueTypeIndex(lua_State* L)
{
    LuaValueTypeData* data = LuaDataContainer::GetValueType(L, 1);
    const char* key = luaL_checkstring(L, 2);

    FieldInfoData* fieldInfo = nullptr;

    ValueTypeInfoData* infoData = (ValueTypeInfoData*)data->type->typeInfoData;
    KYBER_LOG(Debug, "Getting field for " << infoData->name << ": " << key << " " << std::hex << infoData);

    for (int i = 0; i < infoData->fieldCount; i++)
    {
        FieldInfoData& field = infoData->fields[i];
        if (strcicmp(field.name, key) != 0)
        {
            continue;
        }

        fieldInfo = &field;
        break;
    }

    if (fieldInfo == nullptr)
    {
        KYBER_LOG(Error, "Failed to find field to create a value type property reader for " << infoData->name << ": " << key);
    nil:
        lua_pushnil(L);
        return 1;
    }

    int result = TypeInfoIndex(L, data->value, fieldInfo);
    if (result == 0)
    {
        goto nil;
    }

    return 1;
}

static int ValueTypeNewIndex(lua_State* L)
{
    LuaValueTypeData* data = LuaDataContainer::GetValueType(L, 1);
    const char* key = luaL_checkstring(L, 2);

    FieldInfoData* fieldInfo = nullptr;

    ValueTypeInfoData* infoData = (ValueTypeInfoData*)data->type->typeInfoData;
    KYBER_LOG(Debug, "Setting field for " << infoData->name << ": " << key << " " << std::hex << infoData);

    for (int i = 0; i < infoData->fieldCount; i++)
    {
        FieldInfoData& field = infoData->fields[i];
        if (strcicmp(field.name, key) != 0)
        {
            continue;
        }

        fieldInfo = &field;
        break;
    }

    if (fieldInfo == nullptr)
    {
        KYBER_LOG(Error, "Failed to find field to create a property writer for " << infoData->name << ": " << key);
        return 0;
    }

    return TypeInfoNewIndex(L, data->value, fieldInfo);
}

static int LuaUnimplemented(lua_State* L)
{
    luaL_error(L, "Unimplemented function");
    return 0;
}

static int ValueTypeGc(lua_State* L)
{
    LuaValueTypeData* data = LuaDataContainer::GetValueType(L, 1);
    if (data->owned)
    {
        KYBER_LOG(Info, "Freeing value type: " << std::hex << data->value);
        FB_GLOBAL_ARENA->free(data->value);
    }
    return 0;
}

// clang-format off
static const luaL_Reg s_typeInfoMeta[] = {
    { "__index", RawTypeInfoIndex },
    { NULL, NULL }
};

static const luaL_Reg s_dataContainerMeta[] = {
    { "__index", DataContainerIndex },
    { "__newindex", DataContainerNewIndex },
    { NULL, NULL }
};

static const luaL_Reg s_valueTypeMeta[] = {
    { "__index", ValueTypeIndex },
    { "__newindex", ValueTypeNewIndex },
    { "__add", LuaUnimplemented },
    { "__sub", LuaUnimplemented },
    { "__mul", LuaUnimplemented },
    { "__div", LuaUnimplemented },
    { "__unm", LuaUnimplemented },
    { "__eq", LuaUnimplemented },
    { "__tostring", LuaUnimplemented },
    { "__gc", ValueTypeGc },
    { NULL, NULL }
};
// clang-format on

void LuaDataContainer::Register(lua_State* lua)
{
    luaL_newmetatable(lua, "TypeInfo");
    luaL_setfuncs(lua, s_typeInfoMeta, 0);

    luaL_newmetatable(lua, "DataContainer");
    luaL_setfuncs(lua, s_dataContainerMeta, 0);

    luaL_newmetatable(lua, "ValueType");
    luaL_setfuncs(lua, s_valueTypeMeta, 0);

    LuaDataContainer::RegisterTypeConstructors(lua);
    // lua_pushvalue(L, -1);
}

const TypeInfo** LuaDataContainer::WrapTypeInfo(lua_State* L, const TypeInfo* info)
{
    const TypeInfo** userdata = (const TypeInfo**)lua_newuserdata(L, sizeof(TypeInfo*));
    *userdata = info;
    return userdata;
}

const DataContainer** LuaDataContainer::WrapDataContainer(lua_State* L, const DataContainer* container)
{
    const DataContainer** userdata = (const DataContainer**)lua_newuserdata(L, sizeof(DataContainer*));
    *userdata = container;
    return userdata;
}

LuaValueTypeData* LuaDataContainer::WrapValueType(lua_State* L, const TypeInfo* type, void* value)
{
    LuaValueTypeData* userdata = (LuaValueTypeData*)lua_newuserdata(L, sizeof(LuaValueTypeData));
    userdata->type = type;
    userdata->value = value;
    return userdata;
}

static int DataContainerCreateFunc(lua_State* L)
{
    TypeInfo* info = (TypeInfo*)lua_touserdata(L, lua_upvalueindex(1));
    KYBER_LOG(Info, "Creating instance of " << info->typeInfoData->name);

    DataContainer* container = DataContainerClassInfo_createInstance(info, FB_GLOBAL_ARENA, true, true);
    LuaDataContainer::WrapDataContainer(L, container);

    luaL_getmetatable(L, "DataContainer");
    lua_setmetatable(L, -2);
    return 1;
}

void* LuaDataContainer::ValueTypeCreate(lua_State* L, const TypeInfo* info)
{
    KYBER_LOG(Debug, "Creating instance of " << info->typeInfoData->name);

    void* value = FB_GLOBAL_ARENA->alloc(info->typeInfoData->totalSize);

    ValueTypeCreationInfo creationInfo{ FB_GLOBAL_ARENA, info };
    reinterpret_cast<ValueTypeInfoData*>(info->typeInfoData)->createFunc(value, creationInfo);

    auto val = LuaDataContainer::WrapValueType(L, info, value);
    val->owned = true;

    luaL_getmetatable(L, info->typeInfoData->name);
    lua_setmetatable(L, -2);
    return value;
}

static int ValueTypeCreateFunc(lua_State* L)
{
    TypeInfo* info = (TypeInfo*)lua_touserdata(L, lua_upvalueindex(1));
    LuaDataContainer::ValueTypeCreate(L, info);
    return 1;
}

void LuaDataContainer::RegisterTypeConstructors(lua_State* L)
{
    TypeInfo* firstTypeInfo = (TypeInfo*)0x144742650;
    for (TypeInfo* info = firstTypeInfo; info; info = info->next)
    {
        const char* name = info->typeInfoData->name;
        lua_getglobal(L, name);
        if (!lua_isnil(L, -1))
        {
            lua_pop(L, 1);
            continue;
        }

        lua_pop(L, 1);

        lua_pushlightuserdata(L, info);

        if (info->getBasicType() == kTypeCode_Class && info->isKindOf(typeInfo_DataContainer))
        {
            lua_pushcclosure(L, DataContainerCreateFunc, 1);
        }
        else if (info->getBasicType() == kTypeCode_ValueType)
        {
            lua_pushcclosure(L, ValueTypeCreateFunc, 1);

            luaL_newmetatable(L, name);
            luaL_setfuncs(L, s_valueTypeMeta, 0);

            luaL_getmetatable(L, "ValueType");
            lua_setmetatable(L, -2);
            lua_pop(L, 1);
        }
        else
        {
            lua_pop(L, 1);
            continue;
        }

        lua_setglobal(L, name);
    }
}
} // namespace Kyber