//
//  GameScene.m
//  FlappyBird
//
//  Created by 彭俊龍 on 2017/12/26.
//  Copyright © 2017年 cycu. All rights reserved.
//

#import "GameScene.h"


static int Speed = 6 ;
@implementation GameScene {
    
    
    SKSpriteNode *imageShow1 ;
    SKAction *imageChange1, *imageMove1, *imageConnect1, *imageRepeat1 ;
    SKSpriteNode *imageShow2 ;
    SKAction *imageChange2, *imageMove2, *imageConnect2, *imageRepeat2 ;
    SKSpriteNode *imageFloor1, *imageFloor2 ;
 
    SKSpriteNode *rockShow1;
    SKAction *rockAppear, *rockRemove;

    SKTexture *chartShow1, *chartShow2, *chartShow3 ;
    SKAction  *chart_change, *chart_repeat;
    
    int numRock ;
    NSMutableArray* rockCreate ;
    int numGameOver ;
    float chartPosiY ;
    
    SKLabelNode *gameStatu ;
    SKLabelNode *gameScore ;
    
}

- (void)didMoveToView:(SKView *)view {
    isStart = 0 ;
    
    //init
    chartColl = 1 << 0 ;
    rockColl = 1 << 1;
    floorColl = 1 << 2 ;
    scoreColl = 1 << 3 ;

    //Score
    [self Score];
    
    //Background
    [self BG_Wait:@"BG.png" zPosition:-2 speed:6];
    
    [self BG_Floor:@"fullLaw.png" zPosition:-1 speed:6];
    
   // [self BG_Stop] ;
    
    //Character
    [self Character:@"DinoSprites_wait1.tiff" statu2:@"DinoSprites_wait2.tiff" statu3:@"DinoSprites_wait2.tiff"] ;
    
    isScore = 0 ;
    //[self StartGame] ;
    
}



-(void) StartGame{
    [self BG_Repeat:@"BG.png" zPosition:-2 speed:6];
    [self BG_Floor_Repeat:@"fullLaw.png" zPosition:-1 speed:6];
    numGameOver = 0 ;
    
//    [self createStacles] ;
    [self.physicsWorld setGravity:CGVectorMake(0,-4)] ;
    [self.physicsWorld setContactDelegate:self] ;
    
    mRockNumber = 5 ;

   
    [self Character:@"DinoSprites_walk1.tiff" statu2:@"DinoSprites_walk2.tiff" statu3:@"DinoSprites_walk3.tiff"] ;
    //[self Character:@"DinoSprites_jump1.tiff" statu2:@"DinoSprites_jump2.tiff" statu3:@"DinoSprites_jump3.tiff"] ;
    //[self Character:@"DinoSprites_die1.tiff" statu2:@"DinoSprites_die2.tiff" statu3:@"DinoSprites_die3.tiff"] ;
    //[self Character:@"DinoSprites_fast1.tiff" statu2:@"DinoSprites_fast2.tiff" statu3:@"DinoSprites_fast3.tiff"] ;`
}

-(void)onTime:(NSTimer*)timer{
    if( isStart >= 1 ) isScore ++ ;
    
    scoreShow.text = [NSString stringWithFormat:@"Score: %d", isScore] ;
    
    int AddRock = ( rand()%10 +1 );
    if ( AddRock < mRockNumber )
        [self Rock:@"rock1.png" rockShow:CGRectGetWidth(self.frame) zPosition:3 speed:6];
}

-(void)Score {
    scoreShow = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    scoreShow.text = [NSString stringWithFormat:@"Score: %d", isScore] ;
    scoreShow.fontSize = 32 ;
    scoreShow.fontColor = [UIColor blackColor] ;
    scoreShow.position = CGPointMake(250, 170);
    
    
    [self addChild:scoreShow];
}

-(void) BG_Wait:(NSString*)filename zPosition:(float)zPosition speed:(float)speed{
    imageShow1 = [SKSpriteNode spriteNodeWithImageNamed:filename];
    imageShow1.zPosition = zPosition;
    imageShow1.size = CGSizeMake(imageShow1.size.width/2,imageShow1.size.height/2);
    imageShow1.position = CGPointMake(0, 0) ;
  
    [self addChild:imageShow1] ;
    

    
}

-(void) BG_Repeat:(NSString*)filename zPosition:(float)zPosition speed:(float)speed{

  //  imageShow1.size = CGSizeMake(imageShow1.size.width/2,imageShow1.size.height/2);
 //   imageShow1.position = CGPointMake(0, 0) ;
    imageChange1 = [SKAction moveTo:CGPointMake(-(imageShow1.size.width), CGRectGetMidY(self.frame)) duration:speed];
    imageMove1 = [SKAction moveTo:imageShow1.position duration:0] ;
    imageConnect1 = [SKAction sequence:@[imageChange1, imageMove1]];
    imageRepeat1 = [SKAction repeatActionForever:imageConnect1];
    [imageShow1 runAction:imageRepeat1] ;
    
    
    imageShow2 = [SKSpriteNode spriteNodeWithImageNamed:filename];
    imageShow2.zPosition = zPosition;
    imageShow2.size = CGSizeMake(imageShow1.size.width,imageShow1.size.height);
    imageShow2.position = CGPointMake(CGRectGetMidX(self.frame)+imageShow1.size.width ,CGRectGetMidY(self.frame));
    imageChange2 = [SKAction moveTo:imageShow1.position duration:speed];
    imageMove2 = [SKAction moveTo:imageShow2.position duration:0];
    imageConnect2 = [SKAction sequence:@[imageChange2,imageMove2]];
    imageRepeat2 = [SKAction repeatActionForever:imageConnect2];
    [imageShow2 runAction:imageRepeat2];
    [self addChild:imageShow2];
    
}


-(void) BG_Floor:(NSString*)filename zPosition:(float)zPosition speed:(float)speed{
    imageFloor1 = [SKSpriteNode spriteNodeWithImageNamed:filename];
    imageFloor1.zPosition = zPosition;
    imageFloor1.size = CGSizeMake(imageFloor1.size.width/2,imageFloor1.size.height/2);
    imageFloor1.position = CGPointMake(0, -CGRectGetMidY(self.view.frame)-10) ;
    [self addChild:imageFloor1] ;
    
    imageFloor1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(imageFloor1.size.width, imageFloor1.size.height)] ;
    imageFloor1.physicsBody.dynamic = false ;
    imageFloor1.physicsBody.categoryBitMask = floorColl ; //碰撞
    imageFloor1.name = @"floor" ;
}

-(void) BG_Floor_Repeat:(NSString*)filename zPosition:(float)zPosition speed:(float)speed{
    imageFloor1.position = CGPointMake(0, -CGRectGetMidY(self.view.frame)-10) ;
    imageChange1 = [SKAction moveTo:CGPointMake(-(imageFloor1.size.width), -CGRectGetMidY(self.view.frame)-10) duration:speed];
    imageMove1 = [SKAction moveTo:imageFloor1.position duration:0] ;
    imageConnect1 = [SKAction sequence:@[imageChange1, imageMove1]];
    imageRepeat1 = [SKAction repeatActionForever:imageConnect1];
    [imageFloor1 runAction:imageRepeat1] ;
    
    imageFloor2 = [SKSpriteNode spriteNodeWithImageNamed:filename];
    imageFloor2.zPosition = zPosition;
    imageFloor2.size = CGSizeMake(imageFloor1.size.width,imageFloor1.size.height);
    imageFloor2.position = CGPointMake(CGRectGetMidX(self.frame)+imageFloor1.size.width ,-CGRectGetMidY(self.view.frame)-10);
    imageChange2 = [SKAction moveTo:imageFloor1.position duration:speed];
    imageMove2 = [SKAction moveTo:imageFloor2.position duration:0];
    imageConnect2 = [SKAction sequence:@[imageChange2,imageMove2]];
    imageRepeat2 = [SKAction repeatActionForever:imageConnect2];
    [imageFloor2 runAction:imageRepeat2];
    [self addChild:imageFloor2];
    
    imageFloor2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(imageFloor2.size.width, imageFloor2.size.height-10)] ;
    imageFloor2.physicsBody.dynamic = false ;
    imageFloor2.physicsBody.categoryBitMask = floorColl ; //碰撞
    imageFloor2.name = @"floor" ;
}

-(void) Rock:(NSString*)filename rockShow:(float)positionx zPosition:(float)zPosition speed:(float)speed {
    rockShow1 = [SKSpriteNode spriteNodeWithImageNamed:filename] ;
    rockShow1.size = CGSizeMake(90, 75);
    rockShow1.zPosition = zPosition ;
    rockShow1.position = CGPointMake(positionx, CGRectGetMinY(self.frame)+490);
    
    rockAppear = [SKAction moveToX:-CGRectGetMaxX(self.view.frame) duration:speed];
    rockRemove = [SKAction removeFromParent] ;

    [rockShow1 runAction:[SKAction sequence:@[rockAppear, rockRemove]]] ;
    [rockShow1 runAction:rockAppear] ;

    [self addChild:rockShow1] ;
    
    rockShow1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(rockShow1.size.width, rockShow1.size.height)] ;
    rockShow1.physicsBody.dynamic = false ;
    rockShow1.physicsBody.categoryBitMask = rockColl ; //碰撞
    rockShow1.name = @"rock" ;
}



-(void) Character:(NSString*)statu1 statu2:(NSString*)statu2 statu3:(NSString*)statu3 {
    chartShow1 = [SKTexture textureWithImageNamed:statu1];
    chartShow2 = [SKTexture textureWithImageNamed:statu2];
    chartShow3 = [SKTexture textureWithImageNamed:statu3];
    chart_change = [SKAction animateWithTextures:@[chartShow1,chartShow2,chartShow3] timePerFrame:0.25f];
    chart_repeat = [SKAction repeatActionForever:chart_change];
    chartAction = [SKSpriteNode spriteNodeWithTexture:chartShow1] ;
    //character = [SKSpriteNode spriteNodeWithTexture:chartShow1];
    chartAction.zPosition = 2 ;
    chartAction.size = CGSizeMake(90, 85) ;
    chartAction.position = CGPointMake(CGRectGetMinX(self.view.frame)-300, -CGRectGetMidY(self.view.frame)+50) ;
     chartPosiY = -CGRectGetMidY(self.view.frame)+50 ;
    [chartAction runAction:chart_repeat];
    [self addChild:chartAction];
    
    
    
    chartAction.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(chartShow1.size.width, chartShow1.size.height)] ; //碰撞到障礙物
    chartAction.physicsBody.dynamic = YES; // 地心引力
    chartAction.physicsBody.allowsRotation = NO ; //不會旋轉
    chartAction.physicsBody.categoryBitMask = chartColl ;
    chartAction.physicsBody.collisionBitMask = floorColl | rockColl  ; //設計被誰撞到
    chartAction.physicsBody.contactTestBitMask = rockColl | floorColl ; // 被撞動作
    chartAction.name = @"character" ;
}

-(void) didBeginContact:(SKPhysicsContact *)contact{ //碰撞事件發生
    NSString* collA = contact.bodyA.node.name ; //碰撞體Ａ
    NSLog(@"A: %@", collA); // 顯示碰撞體名稱
    
    NSString* collB = contact.bodyB.node.name ;
    NSLog(@"B: %@", collB);
    
    
    
    if( [collA isEqualToString:@"rock"] || [collB isEqualToString:@"rock"]) {
        if(isStart >= 2){
        isStart = 0 ;
        
        endScore = isScore ;
        //isScore = 0 ;
        gameStatu = [SKLabelNode labelNodeWithFontNamed:@"chalkduster"] ;
        gameScore = [SKLabelNode labelNodeWithFontNamed:@"chalkduster"] ;
        gameStatu.text = [NSString stringWithFormat:@"Game Over"];
        gameStatu.fontSize = 64 ;
        gameStatu.zPosition = 10 ;
        gameStatu.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)) ;
        gameStatu.fontColor = [UIColor redColor] ;
        
        gameScore.fontSize =50 ;
        gameScore.zPosition = 10 ;
        gameScore.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-50) ;
        
        gameStatu.fontColor = [UIColor redColor] ;
        
        if(endScore != 0) {
            [self addChild:gameStatu] ;
            [self addChild:gameScore] ;
           
            [chartAction removeFromParent] ;
                [self Character:@"DinoSprites_die1.tiff" statu2:@"DinoSprites_die2.tiff" statu3:@"DinoSprites_die3.tiff"] ;
            [imageShow1 removeAllActions] ;
            [imageFloor1 removeAllActions] ;
            [imageShow2 removeAllActions] ;
            [imageFloor2 removeAllActions] ;
        
            [timer invalidate];
            [rockShow1 removeAllActions] ;
            Speed = 0 ;
        }}
    }
    gameScore.text =[NSString stringWithFormat:@"Score:%d",endScore] ;
    
}

-(void) startTimer {
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(onTime:)
                                           userInfo:nil
                                            repeats:YES] ;
}
-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if( isStart == 0 ) {
        [scoreShow removeFromParent] ;
        [gameScore removeFromParent] ;
        [gameStatu removeFromParent] ;
        [rockShow1 removeFromParent] ;
        [rockShow1 removeAllChildren] ;
        [chartAction removeFromParent] ;
      //  [rockShow1 removeFromParent] ;
        //init
        chartColl = 1 << 0 ;
        rockColl = 1 << 1;
        floorColl = 1 << 2 ;
        scoreColl = 1 << 3 ;
        //Score
        [self Score];
        
        //Background
        [self BG_Wait:@"BG.png" zPosition:-2 speed:6];
        [self BG_Floor:@"fullLaw.png" zPosition:-1 speed:6];
        
        //Character
        [self Character:@"DinoSprites_wait1.tiff" statu2:@"DinoSprites_wait2.tiff" statu3:@"DinoSprites_wait2.tiff"] ;
        
        isScore = 0 ;
        
        //[self StartGame] ;
        isStart=1;
         [self startTimer] ;
    }
    if(isStart == 1){
        [chartAction removeFromParent] ;
        
        [self StartGame] ;
        isStart = 2;

    }
    else if ( isStart >= 2 ) {
        NSLog( @"now %f",chartAction.frame.origin.y) ;
        NSLog( @"123 %f",chartPosiY) ;
      //  float chartPosiY = chartAction.frame.origin.y ;
        if ( chartAction.frame.origin.y <=  -190  )
            [chartAction.physicsBody applyForce:CGVectorMake(0, 580)] ;
        
        Speed = 6;
    }
}


-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered

   // [self updateObstacles:currentTime];
    
}

@end
