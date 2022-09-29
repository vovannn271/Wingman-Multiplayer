using UnityEngine;
using UnityEngine.EventSystems;
using Opsive.Shared.Input.VirtualControls;
using UnityEngine.UI;

public class VirtualJoystickMovement : VirtualAxis, IDragHandler
{
    [Tooltip( "A reference to the joystick that moves with the press position." )]
    [SerializeField] protected RectTransform m_Joystick;
    [Tooltip( "The maximum number of pixels that the joystick can move." )]
    [SerializeField] protected float m_Radius = 100;
    [Tooltip( "The joystick will return a zero value when the radius is within the specified deadzone radius of the center." )]
    [SerializeField] protected float m_DeadzoneRadius = 5;
    [Tooltip( "Max amount where joystick will stay" )]
    [SerializeField] private float maxDragForStay = 90f;

    private Transform m_CanvasScalarTransform;
    private Vector2 m_JoystickStartPosition;

    private float xPosAbs;
    private float yPosAbs;
    private bool m_JoystickCornerStay = false;
    private Vector2 m_cashedDeltaPosition;
    private Vector2 validPosition;


    protected override void Awake()
    {
        if (m_Joystick == null)
        {
            Debug.LogError( "Error: A joystick transform must be specified." );
            enabled = false;
            return;
        }
        m_CanvasScalarTransform = GetComponentInParent<CanvasScaler>().transform;
        m_JoystickStartPosition = m_Joystick.anchoredPosition;

        base.Awake();
    }

    

    /// <summary>
    /// Callback when a pointer has dragged the button.
    /// </summary>
    /// <param name="data">The pointer data.</param>
    public void OnDrag( PointerEventData data )
    {
        var canvasScale = m_CanvasScalarTransform == null ? Vector3.one : m_CanvasScalarTransform.localScale;
        m_DeltaPosition.x += data.delta.x / canvasScale.x;
        m_DeltaPosition.y += data.delta.y / canvasScale.y;
        m_DeltaPosition.x = Mathf.Clamp( m_DeltaPosition.x, -m_Radius, m_Radius );
        m_DeltaPosition.y = Mathf.Clamp( m_DeltaPosition.y, -m_Radius, m_Radius );
        if (m_DeltaPosition.magnitude > m_Radius)
        {
            m_DeltaPosition = m_DeltaPosition.normalized * m_Radius;
        }

        if ( m_DeltaPosition.x != 0 && m_DeltaPosition.y != 0)
        {
            m_cashedDeltaPosition = m_DeltaPosition;
        }
        // Update the joystick position.
        m_Joystick.anchoredPosition = m_JoystickStartPosition + m_DeltaPosition;
    }

    /// <summary>
    /// Callback when a finger has released the button.
    /// </summary>
    /// <param name="data">The pointer data.</param>
    public override void OnPointerUp( PointerEventData data )
    {
        if (!m_Pressed)
        {
            return;
        }

        base.OnPointerUp( data );

        xPosAbs = Mathf.Abs( m_Joystick.anchoredPosition.x );
        yPosAbs = Mathf.Abs( m_Joystick.anchoredPosition.y );
        if ( xPosAbs > maxDragForStay || yPosAbs > maxDragForStay
            || (xPosAbs + yPosAbs) > maxDragForStay)
        {
            m_JoystickCornerStay = true;
            return;
        }

        m_Joystick.anchoredPosition = m_JoystickStartPosition;
        m_JoystickCornerStay = false;
    }

    /// <summary>
    /// Returns the value of the axis.
    /// </summary>
    /// <param name="buttonName">The name of the axis.</param>
    /// <returns>The value of the axis.</returns>
    public override float GetAxis( string buttonName )
    {
        if (!m_Pressed && !m_JoystickCornerStay )
        {
            return 0;
        }


        
        if (m_DeltaPosition.x == 0 && m_DeltaPosition.y == 0)
        {
            validPosition = m_cashedDeltaPosition;
        }
        else
        {
            validPosition = m_DeltaPosition;
        }

        
        if (buttonName == m_HorizontalInputName)
        {
            if (Mathf.Abs( validPosition.x ) > m_DeadzoneRadius)
            {
                return validPosition.x / m_Radius;
            }
        }
        else
        {
            if (Mathf.Abs( validPosition.y ) > m_DeadzoneRadius)
            {
                return validPosition.y / m_Radius;
            }
        
        }

        return 0;
    }
}
