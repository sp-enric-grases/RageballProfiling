//-----------------------------------------------------------------------
// BallEffect.cs
//
// Copyright 2019 Social Point SL. All rights reserved.
//
//-----------------------------------------------------------------------
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BallEffect : MonoBehaviour
{
    [SerializeField] private List<Material> terrains = new List<Material>();
    [SerializeField] private Vector2 rangeYPosition = new Vector2(3, 5);

    private Vector3 _ballPos;

    private void Awake()
    {
        SetNewBallPosition();
    }

    void Update()
    {
        if(transform.position == _ballPos) return;

        for(int i = 0; i < terrains.Count; i++)
        {
            Vector4 pos = terrains[i].GetVector("_POSITION");
            pos.x = transform.position.x;
            pos.z = transform.position.z;
            terrains[i].SetVector("_POSITION", pos);

            UseYPosition();
        }

        SetNewBallPosition();
    }

    private void UseYPosition()
    {
        float yValue = (transform.position.y - rangeYPosition.y) / (rangeYPosition.x - rangeYPosition.y);
        yValue = Mathf.Clamp01(yValue);

        for(int i = 0; i < terrains.Count; i++)
        {
            terrains[i].SetFloat("_HeightOpacity", yValue);
        }
    }

    private void SetNewBallPosition()
    {
        _ballPos = transform.position;
    }
}
