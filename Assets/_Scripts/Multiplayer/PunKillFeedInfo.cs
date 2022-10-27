using UnityEngine;
using Opsive.UltimateCharacterController.Traits;
using Photon.Pun;
using Photon.Realtime;
using Opsive.Shared.Events;
using Opsive.Shared.Game;

public class PunKillFeedInfo : MonoBehaviour
{
    private Health _health;
    private PhotonView _viewId;


    private void Awake()
    {
        _health = null;
        EventHandler.RegisterEvent<Player, GameObject>( "OnPlayerEnteredRoom", OnPlayerEnteredRoom );
    }

    private void OnPlayerEnteredRoom( Player player, GameObject character )
    {

        if (player == null || character == null)
        {
            return;
        }

        if (player.IsLocal)
        { 
            //if already initialized
            if ( _health != null)
            {
                return;
            }

            //Debug.Log( "PlayerEnteredTheRoom " + player.NickName );
            InitializeLocalPlayerForKillfeed( player, character );
        }
    }
    

    private void InitializeLocalPlayerForKillfeed( Player player, GameObject character )
    {
        _health = character.GetCachedComponent<Health>();
        _viewId = character.GetCachedComponent<PhotonView>();

        _health.OnDeathEvent.AddListener( ( Vector3 pos, Vector3 force, GameObject attacker ) => {
            if ( _viewId.IsMine)
            {
                PhotonView attackerView = attacker.GetComponent<PhotonView>();
                _viewId.RPC( "OnDeathSync", RpcTarget.All, _viewId.Owner.NickName, attackerView.Owner.NickName );
            }
        } );
    }
    /*[PunRPC]
    public void OnDeathSync( string victimNickName, string attackerNickName, PhotonMessageInfo info )
    {
        Debug.Log( "Player " + info.Sender.NickName + " was killed by " + attackerNickName );
    }*/


    private void OnDestroy()
    {
        EventHandler.UnregisterEvent<Player, GameObject>( "OnPlayerEnteredRoom", OnPlayerEnteredRoom );
        _health.OnDeathEvent.RemoveAllListeners();
    }
}