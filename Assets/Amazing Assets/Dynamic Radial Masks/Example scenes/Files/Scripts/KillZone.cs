using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace AmazingAssets
{
    namespace DynamicRadialMasks
    {
        public class KillZone : MonoBehaviour
        {
            public float groundLevel = 0;

            void FixedUpdate()
            {
                if (transform.position.y < groundLevel)
                    GameObject.Destroy(this.gameObject);
            }
        }
    }
}