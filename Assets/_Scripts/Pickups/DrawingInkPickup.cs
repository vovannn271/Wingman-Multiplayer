using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Opsive.UltimateCharacterController.Traits;
using Opsive.Shared.Game;
using Opsive.UltimateCharacterController.Objects.CharacterAssist;

[RequireComponent( typeof( AttributeManager ) )]
public class DrawingInkPickup : ObjectPickup
{
    [Tooltip( "Name of changed attribute" )]
    [SerializeField] private string attributeName = "DrawingInk";
    [Tooltip( "The amount of ink to replenish." )]
    [SerializeField] private float _inkAmount = 40;
    [Tooltip( "Should the object be picked up even if the object has full shield?" )]
    [SerializeField] private bool m_AlwaysPickup;

    public float InkAmount { get { return _inkAmount; } set { _inkAmount = value; } }
    public bool AlwaysPickup { get { return m_AlwaysPickup; } set { m_AlwaysPickup = value; } }

    /// <summary>
    /// A GameObject has entered the trigger.
    /// </summary>
    /// <param name="other">The GameObject that entered the trigger.</param>
    public override void TriggerEnter( GameObject other )
    {
        DoPickup( other );
    }

    /// <summary>
    /// Picks up the object.
    /// </summary>
    /// <param name="target">The object doing the pickup.</param>
    public override void DoPickup( GameObject target )
    {
        AttributeManager attributeManager = target.GetCachedParentComponent<AttributeManager>();
        Attribute attribute = null;
        
       
        if ( attributeManager != null)
        {
            attribute =  attributeManager.GetAttribute( attributeName );
        }

        if (attribute != null )
        {
            attribute.Value += _inkAmount;
            ObjectPickedUp( attributeManager.gameObject );
        }
    }
}
