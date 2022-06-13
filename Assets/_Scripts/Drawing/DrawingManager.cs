using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DrawingManager : MonoBehaviour
{
    private bool[] TargetMeshIDs;
    private int arrSize = 0;

    void Start()
    {
        TargetMeshIDs = new bool[100000];
    }

    
    public int TakeTargetMeshId()
    {
        TargetMeshIDs[arrSize] = true;
        return arrSize++;
    }
    public void RemoveTargetMeshId( int id )
    {
        TargetMeshIDs[id] = false;
    }


}
