# IOSTool
Personal little tool

---

####UIButton+Block
**在初始化的时候通过block完成时间绑定**

```
_orderButton = [UIButton buttonWithType:UIButtonTypeCustom withTargetBlock:^(id sender) {
            weakSelf.orderClick();
            [weakSelf remove];
        }];
```

####XMTabberBadge
**因为苹果的badge不支持改颜色，特点写了这个工具**

**set up**

```
self.viewControllers = [NSArray arrayWithObjects:_hotfoodNav,_orderNav,_myNav, nil];
    self.tabBar.badgeColor = [MSColor white];
    self.tabBar.aroundColor = [MSColor red];
    [self.tabBar setUpCustomBadgeView:3];
    
```