using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace TestDynamicBar
{
    [DisallowMultipleComponent]
    [RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
    public class UIDynamicBar : MonoBehaviour
    {
        [Range(0, 1)] public float health = 1;
        public Color initColor = Color.red;
        public Color endColor = Color.green;

        private Mesh mesh;
        private Transform[] wPoints;
        private Vector3[] vertices;
        private Color[] colors;
        private int[] triangles;
        private MeshRenderer render;
        static private MaterialPropertyBlock props;

        void Awake()
        {
            mesh = GetComponent<MeshFilter>().mesh;
            render = GetComponent<MeshRenderer>();

            if (props == null)
                props = new MaterialPropertyBlock();

            SetMeshData();
        }

        private void SetMeshData()
        {
            wPoints = new Transform[4];
            vertices = new Vector3[4];
            colors = new Color[4];

            for (int v = 0; v < transform.childCount; v++)
            {
                wPoints[v] = transform.GetChild(v).transform;
                vertices[v] = wPoints[v].localPosition;
                colors[v] = initColor;
            }

            triangles = new int[6];
            triangles[0] = 0;
            triangles[1] = 2;
            triangles[2] = 1;
            triangles[3] = 1;
            triangles[4] = 2;
            triangles[5] = 3;
        }

        private void Update()
        {
            SetColor(initColor);
            //SetGradientColor(initColor, endColor);
            UpdateHealthBar(health);
        }

        public virtual void UpdateHealthBar(float health)
        {
            vertices[2] = wPoints[0].localPosition + (wPoints[2].localPosition - wPoints[0].localPosition) * health;
            vertices[3] = wPoints[1].localPosition + (wPoints[3].localPosition - wPoints[1].localPosition) * health;

            mesh.vertices = vertices;
            mesh.triangles = triangles;
            mesh.colors = colors;
            mesh.RecalculateNormals();
        }

        public virtual void SetColor(Color initColor)
        {
            for (int c = 0; c < colors.Length; c++)
                colors[c] = initColor;
        }

        public virtual void SetGradientColor(Color initColor, Color endColor)
        {
            colors[0] = initColor;
            colors[1] = initColor;
            colors[2] = Color.Lerp(initColor, endColor, health);
            colors[3] = Color.Lerp(initColor, endColor, health);
        }
    }   
}