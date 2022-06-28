using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Opsive.UltimateCharacterController.Traits;
public class HealthOfDrawing : Health
{
    public MeshExploder MeshExploder {  get; set; }

    public override void Die( Vector3 position, Vector3 force, GameObject attacker )
    {
        if(MeshExploder != null)
        {
            MeshExploder.Explode();
            Debug.Log( "Trying to spawn explosion here" );
        }
        base.Die( position, force, attacker );
        
    }
}
