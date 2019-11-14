using UnityEngine;

namespace TestDynamicBar
{
    public class ZOrderExecution : MonoBehaviour
    {
#if !UNITY_IOS
        void Start()
        {
            GetComponent<Camera>().opaqueSortMode = UnityEngine.Rendering.OpaqueSortMode.NoDistanceSort;
            GetComponent<Camera>().transparencySortMode = TransparencySortMode.Perspective;
        }
#endif
    }
}