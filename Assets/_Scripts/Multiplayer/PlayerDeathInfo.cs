using Opsive.Shared.Events;
using Photon.Pun;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerDeathInfo : MonoBehaviour
{
    [PunRPC]
    public void OnDeathSync( string victimNickName, string attackerNickName, PhotonMessageInfo info )
    {
        EventHandler.ExecuteEvent( "OnKill", info.Sender.NickName, attackerNickName );
    }
}
