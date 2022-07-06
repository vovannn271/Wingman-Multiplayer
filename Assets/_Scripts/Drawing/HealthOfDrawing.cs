using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Opsive.UltimateCharacterController.Traits;

[RequireComponent( typeof( MeshExploder ) )]
public class HealthOfDrawing : Health
{
    public MeshExploder MeshExploder {  get; set; }

    public override void Die( Vector3 position, Vector3 force, GameObject attacker )
    {
        if (MeshExploder != null)
        {
            MeshExploder.Explode();

        }
        else
        {
            Debug.Log( "MeshExploder was not added" );
            MeshExploder = gameObject.AddComponent<MeshExploder>();
            MeshExploder.Explode();
        }
        base.Die( position, force, attacker );
        
    }
}
