using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace TestDynamicBar
{
    [DisallowMultipleComponent]
    [RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
    public class UIDynamicBar : MonoBehaviour
    {
        [Range(0, 1)] public float life;
        public Color color = Color.white;

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
            CreateLifeBar();
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
                colors[v] = color;
            }

            triangles = new int[6];
            triangles[0] = 0;
            triangles[1] = 2;
            triangles[2] = 1;
            triangles[3] = 1;
            triangles[4] = 2;
            triangles[5] = 3;

            CreateLifeBar();
        }

        private void CreateLifeBar()
        {
            mesh.vertices = vertices;
            mesh.triangles = triangles;
            mesh.colors = colors;
            mesh.RecalculateNormals();
        }

        private void Update()
        {
            vertices[2] = wPoints[0].localPosition + (wPoints[2].localPosition - wPoints[0].localPosition) * life;
            vertices[3] = wPoints[1].localPosition + (wPoints[3].localPosition - wPoints[1].localPosition) * life;

            CreateLifeBar();
            ApplyColor();
        }

        public void ApplyColor()
        {
            for (int c = 0; c < colors.Length; c++)
                colors[c] = color;
        }
    }   
}