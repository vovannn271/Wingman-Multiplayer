using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IgnoreRotation : MonoBehaviour
{
    [SerializeField] GameObject _parentRotation;

    // Update is called once per frame
    void LateUpdate()
    {
        this.transform.localRotation = Quaternion.Inverse( _parentRotation.transform.rotation );
        this.transform.localRotation = new Quaternion( 90f, transform.localRotation.y,
            transform.localRotation.z, transform.localRotation.w );
    }
}
