using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace AmazingAssets
{
    namespace DynamicRadialMasks
    {
        public class Follow : MonoBehaviour
        {
            public DRMController drmController;

            public float scale = 1;

            void Update()
            {
                Vector3 position = transform.position;
                position.y = 0;
                

                float maskValue = drmController.GetMaskValue(position);


                position.y = maskValue * scale;

                transform.position = position;
            }
        }
    }
}