using UnityEngine;

namespace TestDynamicBar
{
    public class ScaleHealthBar : MonoBehaviour
    {
        [SerializeField] private Camera healthBarCam;
        [SerializeField] private float factorScale = 27;

        private float dist;
        private float initScale;
        private float scale;

        private void Awake()
        {
            initScale = transform.localScale.x;
        }

        private void Update()
        {
            dist = (healthBarCam.transform.position - transform.position).magnitude;
            scale = dist / factorScale;
            transform.localScale = new Vector3(initScale * scale, initScale * scale, initScale * scale);
        }
    }
}