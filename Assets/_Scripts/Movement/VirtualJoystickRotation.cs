using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Opsive.Shared.Input.VirtualControls;
public class VirtualJoystickRotation : VirtualJoystick
{
    public override float GetAxis( string buttonName )
    {
        if (!m_Pressed)
        {
            return 0;
        }

        if (buttonName == m_HorizontalInputName)
        {
            if (Mathf.Abs( m_DeltaPosition.x ) > m_DeadzoneRadius)
            {
                return -m_DeltaPosition.x / m_Radius;
            }
        }
        else
        {
            if (Mathf.Abs( m_DeltaPosition.y ) > m_DeadzoneRadius)
            {
                return m_DeltaPosition.y / m_Radius;
            }
        }
        return 0;
    }
}


