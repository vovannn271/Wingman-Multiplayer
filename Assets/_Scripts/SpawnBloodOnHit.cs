using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using Opsive.Shared.Events;
public class SpawnBloodOnHit : MonoBehaviour
{
    /// <summary>
    /// Initialize the default values.
    /// </summary>
    public void Awake()
    {
        EventHandler.RegisterEvent<float, Vector3, Vector3,
       GameObject, object, Collider>( gameObject, "OnObjectImpact", OnImpact );
    }
    /// <summary>
    /// The object has been impacted with another object.
    /// </summary>
    /// <param name="amount">The amount of damage taken.</param>
    /// <param name="position">The position of the damage.</param>
    /// <param name="forceDirection">The direction that the object
 /// <param name="attacker">The GameObject that did the
 /// <param name="attackerObject">The object that did the

 /// <param name="hitCollider">The Collider that was hit.</param>
 private void OnImpact( float amount, Vector3 position, Vector3
forceDirection, GameObject attacker, object attackerObject, Collider
hitCollider )
    {
        Debug.Log( name + " impacted by " + attacker + " on collider "
       + hitCollider + "." );

    }
 /// <summary>
 /// The GameObject has been destroyed.
 /// </summary>
 public void OnDestroy()
    {
        EventHandler.UnregisterEvent<float, Vector3, Vector3,
       GameObject, object, Collider>( gameObject, "OnObjectImpact", OnImpact );
    }
}
