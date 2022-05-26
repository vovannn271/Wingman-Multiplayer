using Photon.Pun;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BrushManager : MonoBehaviour
{
    public Camera mainCamera;
    public LayerMask layerMask;
    PhotonView photonView;


    [Tooltip( "The local player instance. Use this to know if the local player is represented in the Scene" )]
    public static GameObject LocalPlayerInstance;


    private void Awake()
    {
        photonView = this.GetComponent<PhotonView>();

        // used in GameManager.cs: we keep track of the localPlayer instance to prevent instantiation when levels are synchronized
        if (photonView.IsMine)
        {
            BrushManager.LocalPlayerInstance = this.gameObject;
            if (mainCamera == null)
            {
                mainCamera = Camera.main;
            }

        }
        // #Critical
        // we flag as don't destroy on load so that instance survives level synchronization, thus giving a seamless experience when levels load.
      //  DontDestroyOnLoad( this.gameObject );



    }


    // Update is called once per frame
    void Update()
    {
        if (photonView.IsMine == false && PhotonNetwork.IsConnected == true)
        {
            return;
        }

        Ray ray = mainCamera.ScreenPointToRay( Input.mousePosition );
        if( Physics.Raycast( ray, out RaycastHit raycastHit, float.MaxValue, layerMask ))
        {
            transform.position = raycastHit.point;
        }
    }
}
