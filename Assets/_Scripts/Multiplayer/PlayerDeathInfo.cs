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
        Debug.Log( "Player " + info.Sender.NickName + " was killed by " + attackerNickName );
        EventHandler.ExecuteEvent( "OnKill", info.Sender.NickName, attackerNickName );
    }
}
