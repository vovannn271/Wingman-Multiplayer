using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Opsive.UltimateCharacterController.Character.Abilities;
using Opsive.UltimateCharacterController.Traits;
using Photon.Pun;

public class DrawingSkill : Ability
{
    
    private AttributeManager _am;
    private Attribute _drawingMana;
    private PUNMeshPaint _brush;
    [SerializeField] private string _attributeName = "DrawingInk";

    public PUNMeshPaint Brush
    {
        get { return _brush; }
        set {
            _brush = value;
            _brush.SetDrawingAbilityValues( this );
        }
    }
    public PhotonView CurrentPlayerPhotonView { get; set; }
    [SerializeField] private float _decreaseAmount = 0.2f;

    public override bool IsConcurrent { get { return true; } }

    public override void Awake()
    {
        base.Awake();
        _am = this.GetComponent<AttributeManager>();
        _drawingMana = _am.GetAttribute( _attributeName );
    }

    public override void Start()
    {
        base.Start();
        
    }

    public override bool CanStartAbility()
    {
        if ( CurrentPlayerPhotonView == null || !base.CanStartAbility())
        {
            return false;
        }

        
        return (_drawingMana.Value > _decreaseAmount );

        
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
            _brush.OnDrawingFinished();
        }
    }
    








    public override void Update()
    {
        base.Update();
        if ( this.IsActive)
        {
            _drawingMana.Value -= _decreaseAmount;

            if ( _drawingMana.Value <= 0)
            {
                this.StopAbility( true );
            }
        }
    }

    public void SetDrawingColor( int colorInt )
    {
        int colorIndex = colorInt % _brush.MP_Color_AvailableColors.Length;
        _brush.MP_CurrentlySelectedAppearanceSlot = colorIndex;
    }
}
