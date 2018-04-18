//
//  GameScene.h
//  FlappyBird
//
//  Created by 彭俊龍 on 2017/12/26.
//  Copyright © 2017年 cycu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene<SKPhysicsContactDelegate>{
    SKSpriteNode *chartAction ;
    SKLabelNode *scoreShow ;
    int isStart ;
    NSTimer *timer;
    int isScore ;
    int endScore ;
    int mRockNumber ;
    int chartColl ;
    int rockColl ;
    int floorColl ;
    int scoreColl ;

}

@end
