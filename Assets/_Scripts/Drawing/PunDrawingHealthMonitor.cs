using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Opsive.UltimateCharacterController.AddOns.Multiplayer.PhotonPun.Traits;
using Opsive.Shared.Game;
using Photon.Pun;

public class PunDrawingHealthMonitor : PunHealthMonitor
{
    private HealthOfDrawing m_HealthOfDrawing;
    protected override void Awake()
    {
        base.Awake();
        m_HealthOfDrawing = m_GameObject.GetCachedComponent<HealthOfDrawing>();
    }


    /// <summary>
    /// The object is no longer alive on the network.
    /// </summary>
    /// <param name="position">The position of the damage.</param>
    /// <param name="force">The amount of force applied to the object while taking the damage.</param>
    /// <param name="attackerViewID">The PhotonView ID of the GameObject that killed the object.</param>
    [PunRPC]
    protected override void DieRPC( Vector3 position, Vector3 force, int attackerViewID )
    {
        PhotonView attacker = null;
        if (attackerViewID != -1)
        {
            attacker = PhotonNetwork.GetPhotonView( attackerViewID );
        }
        m_HealthOfDrawing.Die( position, force, attacker != null ? attacker.gameObject : null );
    }
}
