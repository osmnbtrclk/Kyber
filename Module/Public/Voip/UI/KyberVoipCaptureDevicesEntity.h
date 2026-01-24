#pragma once

#include <Entity/NativeEntityManager.h>

namespace Kyber
{
class KyberVoipCaptureDeviceData : public DataContainer
{
public:
    const char* Identifier;
    const char* DisplayName;
};

class KyberVoipCaptureDevicesData : public DataContainer
{
public:
    FBArray<KyberVoipCaptureDeviceData*> Devices;
    uint32_t CurrentDevice;
    uint32_t MaxDevices;
    bool HasValidData;
    const char* TestString;
};

class KyberVoipCaptureDevicesEntityData : public EntityData
{
public:
    KyberVoipCaptureDevicesData* Response;
    bool Waiting;
};

class KyberVoipCaptureDevicesEntity : public KyberEntity<KyberVoipCaptureDevicesEntityData>
{
public:
    KyberVoipCaptureDevicesEntity(EntityManager* entityManager, NativeEntity* entity, KyberVoipCaptureDevicesEntityData* data);

    void Event(EntityEvent* event) override;
};
} // namespace Kyber
