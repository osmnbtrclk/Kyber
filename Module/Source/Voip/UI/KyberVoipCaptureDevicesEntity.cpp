#include <Voip/UI/KyberVoipCaptureDevicesEntity.h>

#include <Core/Program.h>
#include <Utilities/StringUtils.h>

namespace Kyber
{
KB_IMPLEMENT_TYPE(KyberVoipCaptureDeviceData)
{
    KyberTypeInfo info("KyberVoipCaptureDeviceData", "DataContainer");
    info.AddField("CString", "Identifier");
    info.AddField("CString", "DisplayName");
    return info;
}

KB_IMPLEMENT_TYPE(KyberVoipCaptureDevicesData)
{
    KyberTypeInfo info("KyberVoipCaptureDevicesData", "DataContainer");
    info.AddField("KyberVoipCaptureDeviceData", "Devices", true);
    info.AddField("Uint32", "CurrentDevice");
    info.AddField("Uint32", "MaxDevices");
    info.AddField("Boolean", "HasValidData");
    info.AddField("CString", "TestString");
    return info;
}

KB_IMPLEMENT_TYPE(KyberVoipCaptureDevicesEntityData)
{
    KyberTypeInfo info("KyberVoipCaptureDevicesEntityData", "EntityData");
    info.AddField("KyberVoipCaptureDevicesData", "Response");
    info.AddField("Boolean", "Waiting");
    return info;
}

KB_IMPLEMENT_ENTITY(KyberVoipCaptureDevicesEntity, KyberVoipCaptureDevicesEntityData);

KyberVoipCaptureDevicesEntity::KyberVoipCaptureDevicesEntity(EntityManager* entityManager, NativeEntity* entity, KyberVoipCaptureDevicesEntityData* data)
    : KyberEntity(entity, data)
{
    KYBER_LOG(Info, "Created Voip Capture Devices entity");

    std::vector<KyberVoipCaptureDeviceData*> devices;

    for (int i = 0; i < 5; i++)
    {
        auto* server = entityManager->CreateContainer<KyberVoipCaptureDeviceData>("KyberVoipCaptureDeviceData");
        server->Identifier = StringUtils::CopyWithArena("Device Id " + std::to_string(i));
        server->DisplayName = StringUtils::CopyWithArena("Device Name " + std::to_string(i));
        devices.push_back(server);
    }

    //auto* response = entityManager->CreateContainer<KyberVoipCaptureDevicesData>("KyberVoipCaptureDevicesData"); 
    auto* response = data->Response;
    response->Devices.cloneFromVec(devices);
    response->CurrentDevice = 0;
    response->MaxDevices = devices.size();
    response->HasValidData = false;
    response->TestString = StringUtils::CopyWithArena("Test String");

    //data->Response = response;
    data->Waiting = false;

    WriteField("Response");
    WriteField("Waiting");
}

void KyberVoipCaptureDevicesEntity::Event(EntityEvent* event)
{
    KYBER_LOG(Info, "Voip capture devices event: " << event->eventId);
    WriteField("Response");
    WriteField("Waiting");
}
} // namespace Kyber
