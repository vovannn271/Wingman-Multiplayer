using Photon.Pun;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OnBrushInstanciation : MonoBehaviour, IPunInstantiateMagicCallback 
{
    public void OnPhotonInstantiate( PhotonMessageInfo info )
    {
        object[] instantiationData = info.photonView.InstantiationData;
        int drawingColor = (int)instantiationData[0];
        
        PUNMeshPaint paint = GetComponent<PUNMeshPaint>();
        paint.PUBLIC_ChangeAppearanceIndex( drawingColor - 1);
    }
}
