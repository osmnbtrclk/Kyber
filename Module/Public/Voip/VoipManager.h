#pragma once

#include <Core/DebugHooks.h>
#include <SDK/Types.h>

#include <vxplatform/vxcplatform.h>

#include <VxcEvents.h>
#include <VxcErrors.h>
#include <VxcResponses.h>

#include <vector>
#include <mutex>

namespace Kyber
{
struct VoipLocation
{
    bool valid = false;
    float x = 0, y = 0, z = 0;
    float cameraX = 0, cameraY = 0, cameraZ = 0;
};

struct VoipOrientation
{
    double at_x, at_y, at_z, up_x, up_y, up_z;
};

struct VoipDevice
{
    std::string identifier;
    std::string displayName;
};

struct VoipParticipantState {
    std::string uri;
    bool isSpeaking;
    float audioEnergy;
    bool isMuted;
};

class VoipManager : public ClientUpdatePassListener, public RenderListener
{
public:
    VoipManager();

    void Init();

    void Wakeup();

    void ListenerThread();
    void PositionUpdateThread();

    void AddSession(const std::string& channel, const std::string& accessToken);
    void RemoveSession();

    bool IsLoggedIn() const;
    bool IsConnected() const;

    void SetCaptureDevice(const std::string& identifier);
    void SetRenderDevice(const std::string& identifier);

    bool IsParticipantSpeaking(const char* playerName);
    float GetParticipantAudioEnergy(const char* playerName);

    void SetMuted(bool muted);
    void SetPushToTalkEnabled(bool enabled);
    void SetPushToTalkKey(uint32_t key);
    
    // 0-100, default 50. Logarithmic.
    void SetInputVolume(float volume);
    void SetSpeakerVolume(float volume);
    void SetEnabled(bool enabled);

    // ClientUpdatePassListener
    void Call(ClientUpdatePass pass) override;

    // RenderListener
    void Render() override;

    const std::vector<VoipDevice>& GetCaptureDevices() const
    {
        return m_captureDevices;
    }

    const std::vector<VoipDevice>& GetRenderDevices() const
    {
        return m_renderDevices;
    }

    static vxplatform::os_error_t ListenerThread(void* arg);
    static vxplatform::os_error_t PositionUpdateThread(void* arg);

private:
    void ConvertOrientation(float yaw, float pitch);

    void HandleMessage(vx_message_base_t* msg);
    void SendRequest(vx_req_base_t* req);

    void RequestLogin();

    void Connect(char* loginAccessToken);
    void Login(char* loginAccessToken);
    void AuxGetCaptureDevices();
    void AuxGetRenderDevices();

    void SetPushToTalkPressed(bool pressed);

    vxplatform::os_event_handle m_messageAvailableEvent;

    vxplatform::os_thread_handle m_listenerThread;
    vxplatform::os_thread_id m_listenerThreadId;

    vxplatform::os_thread_handle m_positionUpdateThread;
    vxplatform::os_thread_id m_positionUpdateThreadId;

    std::string m_connectorHandle;

    std::string m_accountHandle;
    std::string m_username;
    std::string m_displayName;
    bool m_isEnabled;
    bool m_isPostLogin;
    bool m_pushToTalkEnabled;
    bool m_isPushToTalkPressed;
    uint32_t m_pushToTalkKey;

    std::string m_currentChannel;

    std::string m_issuer;
    std::string m_domain;

    VoipLocation m_location;
    
    VoipOrientation m_orientation;

    std::vector<VoipDevice> m_captureDevices;
    std::vector<VoipDevice> m_renderDevices;

    Mutex<std::unordered_map<std::string, VoipParticipantState>> m_participants;

    std::mutex m_mutex;
};
} // namespace Kyber