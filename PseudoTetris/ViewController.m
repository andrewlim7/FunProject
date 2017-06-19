//
//  ViewController.m
//  PseudoTetris
//
//  Created by Andrew Lim on 07/06/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet UIView *gameView;
@property (strong,nonatomic) UIDynamicAnimator *animator;
@property (strong,nonatomic) UIGravityBehavior *gravity;
@property (strong,nonatomic) UICollisionBehavior *collision;
@property (strong,nonatomic) UIDynamicItemBehavior *dynamicItemBehavior;

@property (strong,nonatomic) UIView *block;
@property (strong,nonatomic) NSMutableArray *blocks;
@property (weak,nonatomic) UITapGestureRecognizer *tap;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dropBlock:)];
    [self.gameView addGestureRecognizer:tap];
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.gameView];
    self.animator.delegate = self;
    self.dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:self.blocks];
    
    
    
//    self.gravity = [[UIGravityBehavior alloc]initWithItems:self.blocks];
//    self.collision = [[UICollisionBehavior alloc]initWithItems:self.blocks];
    self.gravity = [[UIGravityBehavior alloc]init];
    self.collision = [[UICollisionBehavior alloc]init];

    self.collision.translatesReferenceBoundsIntoBoundary = YES;
    self.dynamicItemBehavior.allowsRotation = NO;
    self.dynamicItemBehavior.elasticity = 0;
    
    [self.animator addBehavior:self.gravity];
    [self.animator addBehavior:self.collision];
    [self.animator addBehavior:self.dynamicItemBehavior];
    
    self.blocks = [[NSMutableArray alloc] init];
    

}

-(void)dropBlock:(UITapGestureRecognizer *)gesture{
    
    //for (int i=0; i < 1; i++){
    
        //NSUInteger randIndex = arc4random_uniform(self.blocksColor.count);//random the color value
        int randomBlock = arc4random() % 6;
        self.block = [self createBlockOnColumn:randomBlock color:[self createRandomColor]];
        [self.blocks addObject:self.block];
    //}

    [self.gravity addItem:self.block];
    [self.collision addItem:self.block];
    [self.dynamicItemBehavior addItem:self.block];
   
//    self.collision.translatesReferenceBoundsIntoBoundary = YES;
//    self.dynamicItemBehavior.allowsRotation = NO;
//    self.dynamicItemBehavior.elasticity = 0;
//    
//    [self.animator addBehavior:self.gravity];
//    [self.animator addBehavior:self.collision];
//    [self.animator addBehavior:self.dynamicItemBehavior];
    
}

-(UIColor *)createRandomColor{
    
    
    CGFloat aRedValue = arc4random()%255;
    CGFloat aGreenValue = arc4random()%255;
    CGFloat aBlueValue = arc4random()%255;
    
    UIColor *randColor = [UIColor colorWithRed:aRedValue/255.0f green:aGreenValue/255.0f blue:aBlueValue/255.0f alpha:1.0f];
    NSLog(@"%@",randColor);
    return randColor;
}

- (UIView *)createBlockOnColumn:(int)i color:(UIColor *)color {
    //i : (0,5)
    
    self.block = [[UIView alloc]init];
    //NSUInteger randomBlock = arc4random() % 6;
    [self.block setFrame:CGRectMake((i * 65 + 15), 0, 60, 60)];
    
    /*
     
     self.eachGrid = self.view.frame.size.width / 10;
     
     CGFloat randomX = arc4random() %  10
     CGFloat positionX = self.eachGrid * randomX;
     CGRectMake(positionX, 100, self.eachGrid,self.eachGrid);
     
     */
    
    NSLog(@"%d",i);
    [self.block setBackgroundColor:color];
    self.block.layer.cornerRadius = 30;
    
    [self.gameView addSubview:self.block];
    
    return self.block;

}

#pragma mark - UIDynamicAnimator Delegate
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    NSLog(@"pause");
    
    //4. remove when row completed
    //algorithm:
    /*
     --calculate the y-coord of the bottom row |y-bottom|
     
     --loop throught all the block
     --if |block's center| < |y-bottom|
     ----count += 1
     ----save the block
     
     --if count == |column|
     ----remove the block
     */
    int yCoor = self.gameView.frame.size.height - 40; // 736
    NSLog(@"yCoor : %d",yCoor);
    
//    int xBlockCoor = self.block.center.x;
//    int yBlockCoor = self.block.center.y;
//    NSLog(@"X: %d Y: %d",xBlockCoor,yBlockCoor);
    
    //CGPoint centerBlock = CGPointMake(xBlockCoor, yBlockCoor);
    
    int count = 0;
    NSMutableArray *tempBlock = [@[] mutableCopy];
    
    for (int i = 0; i < self.blocks.count ; i ++){
        
        self.block = [self.blocks objectAtIndex:i];
        
        int xBlockCoor = self.block.center.x;
        int yBlockCoor = self.block.center.y;
        //NSLog(@"X: %d Y: %d",xBlockCoor,yBlockCoor);
        
        if(yBlockCoor > yCoor){
            
            [tempBlock addObject:self.block];
            NSLog(@"YES");
            count++;
            NSLog(@"Count %d", count);
            
        }
        
        if (count == 6) {
            
            for (UIView *removeBlock in tempBlock) {
                
                [self.gravity removeItem:removeBlock];
                [self.collision removeItem:removeBlock];
//                [self.animator removeBehavior:self.gravity];
//                [self.animator removeBehavior:self.collision];
//                [self.animator removeBehavior:self.dynamicItemBehavior];
                [removeBlock removeFromSuperview];
                [self.blocks removeObject:removeBlock];
                
            }
//            count = 0;
//            [tempBlock removeObject:tempBlock];
            return;
        }
    }
}

- (void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator
{
    NSLog(@"resume");
}


@end
