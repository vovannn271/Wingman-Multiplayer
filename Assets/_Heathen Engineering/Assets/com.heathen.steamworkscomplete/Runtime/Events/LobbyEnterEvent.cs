﻿#if HE_SYSCORE && STEAMWORKS_NET
using Steamworks;
using UnityEngine.Events;

namespace HeathenEngineering.SteamworksIntegration
{
    [System.Serializable]
    public class LobbyEnterEvent : UnityEvent<LobbyEnter_t> { }
}
#endif