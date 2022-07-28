using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Opsive.UltimateCharacterController.Character.Abilities;
using Opsive.UltimateCharacterController.Traits;
using Photon.Pun;

public class DrawingSkill : Ability
{

    public PUNMeshPaint Brush { get { return _brush; }  set { _brush = value; } }
    public PhotonView CurrentPlayerPhotonView { get; set; }
    [SerializeField] private float _decreaseAmount = 0.2f;
    

    private AttributeManager _am;
    private Attribute _drawingMana;
    private PUNMeshPaint _brush;



    public override bool IsConcurrent { get { return true; } }

    public override void Awake()
    {
        base.Awake();
        _am = this.GetComponent<AttributeManager>();
        _drawingMana = _am.GetAttribute("DrawingMana");
    }

    public override bool CanStartAbility()
    {
        if ( CurrentPlayerPhotonView == null || !base.CanStartAbility())
        {
            return false;
        }

        
        return (_drawingMana.Value > _decreaseAmount );

        
    }

    protected override void AbilityStarted()
    {
        base.AbilityStarted();

        _brush.SetInput( true, false );
    }

    protected override void AbilityStopped( bool force )
    {
        base.AbilityStopped( force );

        if ( CurrentPlayerPhotonView == null)
        {
            return;
        }

        if ( CurrentPlayerPhotonView.IsMine)
        {
            _brush.SetInput( false, true );
        }
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
