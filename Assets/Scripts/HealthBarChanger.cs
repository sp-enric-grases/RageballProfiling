using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HealthBarChanger : MonoBehaviour
{

    MaterialPropertyBlock props;
    MeshRenderer renderer;

    Color color;
    [Range(0, 1)] public float life;
    void Start()
    {
        if(props == null)
            props = new MaterialPropertyBlock();

        renderer = GetComponent<MeshRenderer>();

        life = Random.Range(0.0f, 1.0f);
        color = Color.Lerp(Color.red, Color.green, life);

        props.SetColor("_Color", color);
        props.SetFloat("_Amount",life);

        renderer.SetPropertyBlock(props);
    }

    // Update is called once per frame
    void Update()
    {
        color = Color.Lerp(Color.red, Color.green, life);

        props.SetColor("_Color", color);
        props.SetFloat("_Amount", life);

        renderer.SetPropertyBlock(props);
    }
}
