using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Opsive.UltimateCharacterController.Character.Abilities;
using Opsive.UltimateCharacterController.Traits;


public class DrawingSkill : Ability
{
    private AttributeManager _am;
    private Attribute _drawingMana;
    [SerializeField] private float _decreaseAmount = 0.5f;

    public override void Awake()
    {
        base.Awake();
        _am = this.GetComponent<AttributeManager>();
        _drawingMana = _am.GetAttribute("DrawingMana");
    }

    public override bool CanStartAbility()
    {
        if (!base.CanStartAbility())
        {
            return false;
        }

        return (_drawingMana.Value > _decreaseAmount );
    }


    public override void Update()
    {
        base.Update();
        if ( this.Enabled)
        {
            _drawingMana.Value -= _decreaseAmount;

            if ( _drawingMana.Value <= 0)
            {
                this.StopAbility( true );
            }
        }
    }
}
