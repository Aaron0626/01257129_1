import SwiftUI

// MARK: - 主視圖 Main View
struct ContentView: View {
    // 1. 全域模式控制 (預設為 False = 白天)
    @State private var isGlobalDarkMode: Bool = false
    
    // 2. 個別卡片的反轉狀態
    @State private var flipTopCard: Bool = false
    @State private var flipBottomCard: Bool = false

    // MARK: - 配色定義
    let kavehBg = Color(red: 0.93, green: 0.91, blue: 0.86)
    let kavehMain = Color(red: 0.65, green: 0.25, blue: 0.25)
    let kavehSub = Color(red: 0.25, green: 0.45, blue: 0.55)
    let kavehGold = Color(red: 0.85, green: 0.75, blue: 0.55)

    let alhaithamBg = Color(red: 0.12, green: 0.18, blue: 0.20)
    let alhaithamMain = Color(red: 0.35, green: 0.75, blue: 0.55)
    let alhaithamSub = Color(red: 0.20, green: 0.25, blue: 0.25)
    let alhaithamGold = Color(red: 0.75, green: 0.65, blue: 0.45)

    var body: some View {
        let bgIsDark = isGlobalDarkMode
        
        // 上方卡片配色邏輯
        let topUseDarkPalette = isGlobalDarkMode != flipTopCard
        let topCardPalette = topUseDarkPalette ?
            (bg: kavehBg, main: kavehMain, sub: kavehSub, gold: kavehGold, text: kavehMain) :
            (bg: alhaithamBg, main: alhaithamMain, sub: alhaithamSub, gold: alhaithamGold, text: alhaithamMain)

        // 下方卡片配色邏輯
        let bottomUseDarkPalette = isGlobalDarkMode != flipBottomCard
        let bottomCardPalette = bottomUseDarkPalette ?
            (bg: alhaithamBg, main: alhaithamMain, sub: alhaithamSub, gold: alhaithamGold, text: alhaithamGold) :
            (bg: kavehBg, main: kavehMain, sub: kavehSub, gold: kavehGold, text: kavehMain)

        ZStack {
            // 背景漸層
            LinearGradient(
                colors: bgIsDark ? [alhaithamBg, kavehBg] : [kavehBg, alhaithamBg],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.5), value: isGlobalDarkMode)

            VStack(spacing: 20) {
                
                // 全域切換按鈕
                Button(action: {
                    withAnimation(.spring()) { isGlobalDarkMode.toggle() }
                }) {
                    HStack {
                        Image(systemName: isGlobalDarkMode ? "moon.stars.fill" : "sun.max.fill")
                        Text(isGlobalDarkMode ? "切換至白晝" : "切換至黑夜")
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .foregroundColor(.primary)
                }

                // 艾爾海森
                VStack(spacing: 0) {
                    // 上半部：資訊區
                    HStack {
                        VStack(alignment: .leading) {
                            Text("誨明")
                                .font(.system(size: 28, weight: .black, design: .serif))
                                .foregroundColor(topCardPalette.text)
                        }
                        Spacer()
                        Button(action: { withAnimation { flipTopCard.toggle() } }) {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .foregroundColor(topCardPalette.bg)
                                .padding(12)
                                .background(topCardPalette.main)
                                .clipShape(Circle())
                        }
                    }
                    .padding(20)
                    .background(topCardPalette.bg)
                    
                    Rectangle()
                        .fill(bottomCardPalette.gold.opacity(0.3))
                        .frame(height: 2)
                    
                    // 下半部：圖形區
                    ZStack {
                        Rectangle().fill(topCardPalette.bg) // 背景色
                        
                        // 背景螺旋
                        Group {
                            Circle()
                                .stroke(topCardPalette.sub.opacity(0.3), lineWidth: 40)
                                .frame(width: 400).offset(x: -100, y: 80)
                            Circle()
                                .stroke(topCardPalette.gold.opacity(0.5), lineWidth: 2)
                                .frame(width: 300).offset(x: 100, y: -10)
                        }
                        
                        AlhaithamDarkFillShape()
                            .fill(topCardPalette.sub) // 使用深色輔助色
                            .opacity(0.5) // 設定較高的不透明度，使其看起來更深沉
                            .frame(width: 300, height: 250) // 設定足夠大的尺寸
                            .offset(x: 50, y: -30)
                            .scaleEffect(x: -1, y: -1)
                        
                        AlhaithamRightMantleShape()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        topCardPalette.main.opacity(0.5), // 上方較亮
                                        topCardPalette.sub.opacity(0.3)   // 下方較暗
                                    ],
                                    startPoint: .topTrailing,
                                    endPoint: .bottomLeading
                                )
                            )
                            .frame(width: 350, height: 280)
                            .offset(x: 100, y: 10)
                        
                        AlhaithamLeftMantleShape()
                            .fill(
                                LinearGradient(
                                    colors: [topCardPalette.main.opacity(0.4), topCardPalette.sub.opacity(0.2)],
                                    startPoint: .topTrailing,
                                    endPoint: .bottomLeading
                                )
                            )
                            .frame(width: 300, height: 250) // 尺寸設定
                            .offset(x: -50, y: 100) // 放在左上位置
                        
                        AlhaithamRadianceShape()
                            .fill(topCardPalette.sub.opacity(0.98)) // 使用淡淡的深色或金色
                            .frame(width: 140, height: 100)
                            .offset(x: 80, y: -30) // 放在標誌正後方

                        // 左側金色菱形裝飾 (3顆)
                        AlhaithamSideDiamondsShape()
                            .fill(topCardPalette.gold)
                            .opacity(0.9)
                            .frame(width: 200, height: 245) // 調整框架大小以符合弧度範圍
                            .offset(x: -100, y: -40)

                        // 幾何標誌 (本體)
                        ZStack {
                            // 最底層結構
                            AlhaithamIntricateBottomShape()
                                .fill(topCardPalette.sub)
                                .frame(width: 120, height: 120)
                                .offset(y: 20)
                            
                            // 中層翅膀
                            ZStack {
                                Group {
                                    // 外層金色線框 V 形
                                    Rectangle()
                                        .stroke(topCardPalette.gold, lineWidth: 2.5)
                                        .frame(width: 65, height: 65)
                                        .rotationEffect(.degrees(45))
                                        .offset(y: 12)
                                        .mask(
                                            Rectangle()
                                                .frame(width: 100, height: 50)
                                                .offset(y: 35)
                                        )
                                    
                                    // 內層半透明填充 V 形
                                    Rectangle()
                                        .fill(topCardPalette.gold.opacity(0.4))
                                        .frame(width: 45, height: 45)
                                        .rotationEffect(.degrees(45))
                                        .offset(y: 18)
                                        .mask(
                                            Rectangle()
                                                .frame(width: 80, height: 40)
                                                .offset(y: 30)
                                        )
                                }
                                
                                // 頂部水平鋒利翅膀
                                HStack(spacing: -15) { // 讓左右翅膀稍微重疊連接
                                    // 左側翅膀刀片
                                    Rectangle()
                                        .fill(topCardPalette.gold)
                                        .frame(width: 85, height: 12)
                                        // 稍微旋轉製造上揚角度，錨點設在右側以保持中心連接
                                        .rotationEffect(.degrees(6), anchor: .trailing)
                                        // 加上金色邊框增加銳利感
                                        .overlay(
                                            Rectangle()
                                                .stroke(topCardPalette.gold, lineWidth: 2)
                                                .rotationEffect(.degrees(6), anchor: .trailing)
                                        )
                                        // 使用遮罩切出尖銳的翼尖
                                        .mask(
                                            HStack(spacing: 0) {
                                                Rectangle() // 主體部分
                                                Rectangle() // 用於切割翼尖的旋轉矩形
                                                    .rotationEffect(.degrees(55))
                                                    .offset(x: -10)
                                            }
                                        )
                                    
                                    // 右側翅膀刀片
                                    Rectangle()
                                        .fill(topCardPalette.gold)
                                        .frame(width: 85, height: 12)
                                        .rotationEffect(.degrees(-6), anchor: .leading)
                                        .overlay(
                                            Rectangle()
                                                .stroke(topCardPalette.gold, lineWidth: 2)
                                                .rotationEffect(.degrees(-6), anchor: .leading)
                                        )
                                        .mask(
                                            HStack(spacing: 0) {
                                                Rectangle()
                                                    .rotationEffect(.degrees(-55))
                                                    .offset(x: 10)
                                                Rectangle()
                                            }
                                        )
                                }
                                .offset(y: -30)
                            }
                            .frame(width: 180, height: 100)
                            .offset(y: -25)
                            
                            // 核心寶石
                            ZStack {
                                Rectangle()
                                    .fill(topCardPalette.gold)
                                    .frame(width: 46, height: 46)
                                    .rotationEffect(.degrees(45))
                                Rectangle()
                                    .fill(topCardPalette.sub)
                                    .frame(width: 40, height: 40)
                                    .rotationEffect(.degrees(45))
                                    .overlay(
                                        Rectangle()
                                            .stroke(topCardPalette.gold, lineWidth: 1.5)
                                            .rotationEffect(.degrees(45))
                                    )
                                    .shadow(color: topCardPalette.main.opacity(0.8), radius: 6)
                                Rectangle()
                                    .fill(topCardPalette.gold)
                                    .frame(width: 35, height: 35)
                                    .rotationEffect(.degrees(45))
                                    .offset(y: 10)
                                Rectangle()
                                    .fill(topCardPalette.sub)
                                    .frame(width: 28, height: 28)
                                    .rotationEffect(.degrees(45))
                                    .overlay(
                                        Rectangle()
                                            .stroke(topCardPalette.gold, lineWidth: 1.5)
                                            .rotationEffect(.degrees(45))
                                    )
                                    .shadow(color: topCardPalette.main.opacity(0.8), radius: 6)
                                    .offset(y: 4)
                            }
                            // 中央連接結構
                            ZStack {
                                // 實心金色菱形底
                                Rectangle()
                                    .fill(topCardPalette.gold)
                                    .frame(width: 35, height: 35)
                                    .rotationEffect(.degrees(45))
                                // 利用背景色描邊製造鏤空感
                                Rectangle()
                                    .fill(topCardPalette.main)
                                    .frame(width: 20, height: 20)
                                    .rotationEffect(.degrees(45))
                                    .overlay(
                                        Rectangle()
                                            .stroke(topCardPalette.gold, lineWidth: 1.5)
                                            .rotationEffect(.degrees(45))
                                    )
                                    .shadow(color: topCardPalette.main.opacity(0.8), radius: 6)
                                    .offset(y: 4)
                            }
                            .offset(y: -30) // 位於基座上方，翅膀下方
                        }
                        .offset(x: 80, y: 20)
                    }
                    .frame(height: 180)
                    .clipped()
                }
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                .padding(.horizontal)

                // 卡維
                VStack(spacing: 0) {
                    HStack {
                        Text("穹庭")
                            .font(.system(size: 28, weight: .black, design: .serif))
                            .foregroundColor(bottomCardPalette.text)
                        Spacer()
                        Button(action: { withAnimation { flipBottomCard.toggle() } }) {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .foregroundColor(bottomCardPalette.bg)
                                .padding(12)
                                .background(bottomCardPalette.main)
                                .clipShape(Circle())
                        }
                    }
                    .padding(20)
                    .background(bottomCardPalette.bg)
                    .zIndex(1)
                    
                    Rectangle()
                        .fill(topCardPalette.gold.opacity(0.3))
                        .frame(height: 1)

                    
                    ZStack {
                        Rectangle().fill(bottomCardPalette.bg)
                        
                        Group {
                            // 左側的半透明圓形
                            Circle()
                                .stroke(Color.white.opacity(0.5), lineWidth: 30)
                                .frame(width: 300)
                                .offset(x: -120, y: 50)
                            
                            // 右側的半透明圓形
                            Circle()
                                .stroke(Color.white.opacity(0.45), lineWidth: 40)
                                .frame(width: 350)
                                .offset(x: 100, y: -20)
                            
                            // 中間的菱形網格 (模擬原圖的淺色背景紋理)
                            HStack(spacing: 20) {
                                ForEach(0..<5) { _ in
                                    Rectangle()
                                        .fill(Color.white.opacity(0.1))
                                        .frame(width: 40, height: 40)
                                        .rotationEffect(.degrees(45))
                                }
                            }
                            .offset(y: 60)
                        }

                        // 背景裝飾紋
                        KavehTopDecorationShape()
                            .fill(bottomCardPalette.main) // 紅色紋
                            .frame(width: 300, height: 150)
                            .offset(x: -80, y: -90)
                        
                        KavehTopDecorationShape()
                            .fill(bottomCardPalette.sub) // 藍色紋
                            .frame(width: 300, height: 150)
                            .scaleEffect(x: -1, y: 1) // 鏡像
                            .offset(x: 80, y: -90)

                        // 右側 - 宮殿拱門與稜格
                        ZStack {
                            // 拱門背景
                            KavehDomeShape()
                                .fill(
                                    LinearGradient(colors: [bottomCardPalette.bg, bottomCardPalette.sub.opacity(0.1)], startPoint: .bottom, endPoint: .top)
                                )
                                .frame(width: 200, height: 220)
                            
                            // 金色稜格線條
                            KavehLatticeShape()
                                .stroke(bottomCardPalette.gold, lineWidth: 3)
                                .frame(width: 200, height: 220)
                            
                            // 頂部寶石裝飾
                            Circle()
                                .fill(bottomCardPalette.sub)
                                .frame(width: 20)
                                .overlay(Circle().stroke(bottomCardPalette.gold, lineWidth: 2))
                                .offset(y: -60)
                            
                            // 內部裝飾填色 (模擬彩繪玻璃感)
                            KavehInnerDetailShape()
                                .fill(bottomCardPalette.sub.opacity(0.3))
                                .frame(width: 200, height: 220)
                        }
                        .offset(x: 80, y: 30) // 放在右側

                        // 左側 - 複雜羽毛筆
                        ZStack {
                            // 1. 羽毛底層 (提供顏色和體積感)
                            KavehFeatherShape()
                                .fill(
                                    // 使用徑向漸層：中間骨幹處較深，邊緣較亮，製造立體感
                                    RadialGradient(
                                        colors: [
                                            bottomCardPalette.sub.opacity(0.9), // 中心深色
                                            bottomCardPalette.sub.opacity(0.5)  // 邊緣淺色
                                        ],
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 60
                                    )
                                )
                                .frame(width: 70, height: 190)
                                .offset(x: 0, y: -15)
                            
                            // 2. 羽毛紋理層 (模擬羽枝細節)
                            FeatherBarbTextureShape()
                                .stroke(
                                    // 紋理線條的顏色：使用比底色稍亮的漸層，讓細節跳出來
                                    LinearGradient(
                                        colors: [
                                            bottomCardPalette.sub.opacity(0.3), // 根部較淡
                                            Color.white.opacity(0.4)            // 尖端較亮
                                        ],
                                        startPoint: .bottom,
                                        endPoint: .top
                                    ),
                                    lineWidth: 0.8 // 極細的線條
                                )
                                .frame(width: 80, height: 190)
                                // 關鍵：使用羽毛形狀作為遮罩，讓紋理只顯示在羽毛範圍內
                                .mask(KavehFeatherShape().frame(width: 80, height: 220))
                                .offset(x: 0, y: -15)
                            
                            // 3. 羽毛金色骨幹 (保持不變)
                            Capsule()
                                .fill(
                                    // 給骨幹一點漸層，更有金屬感
                                    LinearGradient(colors: [bottomCardPalette.gold, Color.white], startPoint: .leading, endPoint: .trailing)
                                )
                                .frame(width: 4, height: 200)
                                .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1) // 微小陰影
                            
                            // 4. 筆尖 (保持不變)
                            KavehPenNibShape()
                                .fill(bottomCardPalette.gold)
                                .frame(width: 20, height: 28)
                                .overlay(KavehPenNibShape().stroke(bottomCardPalette.gold.opacity(0.5), lineWidth: 1)) // 邊緣加強
                                .offset(y: 110) // 調整到骨幹末端
                        }
                        .rotationEffect(.degrees(-45)) // 整體旋轉
                        .offset(x: -110, y: -1) // 調整整體位置
                    }
                    .frame(height: 180)
                    .clipped()
                }
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                .padding(.horizontal)
            }
        }
        .environment(\.colorScheme, isGlobalDarkMode ? .dark : .light)
    }
}

// 放射幾何背景 (倒 V 型 / 60度夾角結構)
struct AlhaithamRadianceShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let midX = rect.midX
        let width = rect.width
        let _ = rect.height
        
        // 設定線條寬度 (根據圖形比例調整)
        let thickness = width * 0.18
        
        // 頂點 (Apex)
        let apex = CGPoint(x: midX, y: rect.minY)
        
        // 外側底部點 (Outer Bottom)
        let outerBottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        let outerBottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        
        // 繪製路徑：外側輪廓 -> 內側輪廓 -> 閉合
        path.move(to: outerBottomLeft) // 1. 左下外
        path.addLine(to: apex)         // 2. 頂點
        path.addLine(to: outerBottomRight) // 3. 右下外
        
        // 內側底部右點 (Inner Bottom Right)
        path.addLine(to: CGPoint(x: rect.maxX - thickness, y: rect.maxY))
        
        // 內側頂點 (Inner Apex) - 稍微往下移，保持夾角平行感
        // 簡單計算：內側頂點 Y 軸需要往下移，讓線條看起來等寬
        path.addLine(to: CGPoint(x: midX, y: rect.minY + thickness * 1))
        
        // 內側底部左點 (Inner Bottom Left)
        path.addLine(to: CGPoint(x: rect.minX + thickness, y: rect.maxY))
        
        path.closeSubpath()
        
        return path
    }
}

// 自定義形狀定義
struct AlhaithamSideDiamondsShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let _ = rect.width
        let _ = rect.height
        
        // 定義貝茲曲線路徑 (模擬左下角的弧形飾帶)
        // 起點：左側中間偏下
        let p0 = CGPoint(x: rect.minX, y: rect.maxY * 0.6)
        // 控制點 1
        let p1 = CGPoint(x: rect.width * 0.4, y: rect.maxY * 0.85)
        // 控制點 2
        let p2 = CGPoint(x: rect.width * 0.7, y: rect.maxY * 0.95)
        // 終點：右下角附近
        let p3 = CGPoint(x: rect.maxX, y: rect.maxY)
        
        let diamondCount = 3 // 改為 3 顆
        
        for i in 0..<diamondCount {
            // t 代表路徑進度。我們取 0.2 ~ 0.8 的區間，讓菱形分佈在線條中間，不要太靠邊
            let t = CGFloat(i) / CGFloat(diamondCount - 1) * 0.6 + 0.15
            
            // 三次貝茲曲線公式 (Cubic Bezier Formula)
            let oneMinusT = 1 - t
            let x = pow(oneMinusT, 3) * p0.x +
                    3 * pow(oneMinusT, 2) * t * p1.x +
                    3 * oneMinusT * pow(t, 2) * p2.x +
                    pow(t, 3) * p3.x
            
            let y = pow(oneMinusT, 3) * p0.y +
                    3 * pow(oneMinusT, 2) * t * p1.y +
                    3 * oneMinusT * pow(t, 2) * p2.y +
                    pow(t, 3) * p3.y
            
            let center = CGPoint(x: x, y: y)
            
            // 菱形大小：中間那顆稍微大一點，兩邊小一點 (模擬視覺透視或裝飾感)
            // 根據 i (0, 1, 2) 來變化大小
            let size: CGFloat = (i == 1) ? 22 : 16
            let halfSize = size / 2
            
            // 繪製菱形
            let diamondPath = Path { p in
                p.move(to: CGPoint(x: center.x, y: center.y - halfSize)) // 頂
                p.addLine(to: CGPoint(x: center.x + halfSize, y: center.y)) // 右
                p.addLine(to: CGPoint(x: center.x, y: center.y + halfSize)) // 底
                p.addLine(to: CGPoint(x: center.x - halfSize, y: center.y)) // 左
                p.closeSubpath()
            }
            path.addPath(diamondPath)
        }
        
        return path
    }
}
// 輔助形狀：菱形
struct RhombusShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.closeSubpath()
        return path
    }
}

// 新增：右下角深色填充塊 (位於綠色羽翼後方)
struct AlhaithamDarkFillShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        // 從右下角開始
        path.move(to: CGPoint(x: w, y: h))
        
        // 沿右邊緣向上
        path.addLine(to: CGPoint(x: w, y: h * 0.3))
        
        // 向左延伸的大曲線，填補角落
        path.addCurve(to: CGPoint(x: w * 0.3, y: h),
                      control1: CGPoint(x: w * 0.8, y: h * 0.6),
                      control2: CGPoint(x: w * 0.5, y: h * 0.85))
        
        // 閉合路徑 (回到右下角)
        path.closeSubpath()
        
        return path
    }
}

// 艾爾海森綠色羽毛圍巾
struct AlhaithamRightMantleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        // 從右上角開始
        path.move(to: CGPoint(x: w, y: 0))
        
        // --- 上層大羽翼 ---
        // 向左延伸的大曲線，形成包覆感
        path.addCurve(to: CGPoint(x: w * 0.3, y: h * 0.35),
                      control1: CGPoint(x: w * 0.8, y: h * 0.05),
                      control2: CGPoint(x: w * 0.5, y: h * 0.1))
        
        // 往回鉤的羽翼尖端 (做出銳利感)
        path.addQuadCurve(to: CGPoint(x: w * 0.65, y: h * 0.5),
                          control: CGPoint(x: w * 0.45, y: h * 0.45))
        
        // --- 下層大羽翼 ---
        // 再次向左延伸
        path.addCurve(to: CGPoint(x: w * 0.4, y: h * 0.85),
                      control1: CGPoint(x: w * 0.6, y: h * 0.6),
                      control2: CGPoint(x: w * 0.45, y: h * 0.7))
        
        // 延伸到右下角
        path.addQuadCurve(to: CGPoint(x: w, y: h),
                          control: CGPoint(x: w * 0.7, y: h * 0.95))
        
        // 閉合路徑 (回到右上)
        path.addLine(to: CGPoint(x: w, y: 0))
        path.closeSubpath()
        
        return path
    }
}

// 新增：左側綠色羽翼圍巾 (與右側形成包覆)
struct AlhaithamLeftMantleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        // 從左上角開始
        path.move(to: CGPoint(x: 0, y: 0))
        
        // 向右下延伸的大曲線
        path.addCurve(to: CGPoint(x: w * 0.6, y: h * 0.45),
                      control1: CGPoint(x: w * 0.2, y: h * 0.1),
                      control2: CGPoint(x: w * 0.4, y: h * 0.2))
        
        // 往回鉤的尖端 (銳利感)
        path.addQuadCurve(to: CGPoint(x: w * 0.25, y: h * 0.65),
                          control: CGPoint(x: w * 0.4, y: h * 0.55))
        
        // 向下延伸並收回左側
        path.addQuadCurve(to: CGPoint(x: 0, y: h * 0.9),
                          control: CGPoint(x: w * 0.15, y: h * 0.8))
        
        // 閉合路徑
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.closeSubpath()
        
        return path
    }
}

struct AlhaithamIntricateWingShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let width = rect.width
        let height = rect.height
        path.move(to: CGPoint(x: center.x, y: center.y + height * 0.25))
        path.addLine(to: CGPoint(x: center.x - width * 0.3, y: center.y - height * 0.15))
        path.addLine(to: CGPoint(x: center.x - width * 0.5, y: center.y - height * 0.45))
        path.addLine(to: CGPoint(x: center.x - width * 0.2, y: center.y - height * 0.25))
        path.addLine(to: CGPoint(x: center.x, y: center.y - height * 0.35))
        path.addLine(to: CGPoint(x: center.x + width * 0.2, y: center.y - height * 0.25))
        path.addLine(to: CGPoint(x: center.x + width * 0.5, y: center.y - height * 0.45))
        path.addLine(to: CGPoint(x: center.x + width * 0.3, y: center.y - height * 0.15))
        path.closeSubpath()
        return path
    }
}

struct AlhaithamWingDetailShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let width = rect.width
        let height = rect.height
        path.move(to: CGPoint(x: center.x - width * 0.1, y: center.y - height * 0.1))
        path.addLine(to: CGPoint(x: center.x - width * 0.35, y: center.y - height * 0.3))
        path.move(to: CGPoint(x: center.x + width * 0.1, y: center.y - height * 0.1))
        path.addLine(to: CGPoint(x: center.x + width * 0.35, y: center.y - height * 0.3))
        return path
    }
}

struct AlhaithamIntricateBottomShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let width = rect.width
        let height = rect.height
        path.move(to: CGPoint(x: center.x, y: rect.minY))
        path.addLine(to: CGPoint(x: center.x - width * 0.3, y: rect.minY + height * 0.25))
        path.addLine(to: CGPoint(x: center.x - width * 0.15, y: center.y))
        path.addLine(to: CGPoint(x: center.x - width * 0.35, y: rect.maxY - height * 0.3))
        path.addLine(to: CGPoint(x: center.x, y: rect.maxY))
        path.addLine(to: CGPoint(x: center.x + width * 0.35, y: rect.maxY - height * 0.3))
        path.addLine(to: CGPoint(x: center.x + width * 0.15, y: center.y))
        path.addLine(to: CGPoint(x: center.x + width * 0.3, y: rect.minY + height * 0.25))
        path.closeSubpath()
        let innerPath = Path { p in
            p.move(to: CGPoint(x: center.x, y: center.y + height * 0.2))
            p.addLine(to: CGPoint(x: center.x - width * 0.1, y: center.y + height * 0.5))
            p.addLine(to: CGPoint(x: center.x, y: rect.maxY - height * 0.1))
            p.addLine(to: CGPoint(x: center.x + width * 0.1, y: center.y + height * 0.5))
            p.closeSubpath()
        }
        return Path { p in
            p.addPath(path)
            p.addPath(innerPath)
        }
    }
}

// 1. 宮殿尖頂拱門形狀
struct KavehDomeShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        path.move(to: CGPoint(x: 0, y: h))
        // 繪製左側曲線向上
        path.addCurve(to: CGPoint(x: w/2, y: 0),
                      control1: CGPoint(x: w*0.1, y: h*0.6),
                      control2: CGPoint(x: w*0.4, y: h*0.2))
        // 繪製右側曲線向下
        path.addCurve(to: CGPoint(x: w, y: h),
                      control1: CGPoint(x: w*0.6, y: h*0.2),
                      control2: CGPoint(x: w*0.9, y: h*0.6))
        path.closeSubpath()
        return path
    }
}

// 2. 宮殿金色交錯稜格線條
struct KavehLatticeShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        // 主拱門輪廓
        path.move(to: CGPoint(x: 0, y: h))
        path.addCurve(to: CGPoint(x: w/2, y: 0), control1: CGPoint(x: w*0.1, y: h*0.6), control2: CGPoint(x: w*0.4, y: h*0.2))
        path.addCurve(to: CGPoint(x: w, y: h), control1: CGPoint(x: w*0.6, y: h*0.2), control2: CGPoint(x: w*0.9, y: h*0.6))
        
        // 內部交叉線條 1 (左下往右上)
        path.move(to: CGPoint(x: w*0.2, y: h))
        path.addQuadCurve(to: CGPoint(x: w*0.8, y: h*0.3), control: CGPoint(x: w*0.4, y: h*0.5))
        
        // 內部交叉線條 2 (右下往左上)
        path.move(to: CGPoint(x: w*0.8, y: h))
        path.addQuadCurve(to: CGPoint(x: w*0.2, y: h*0.3), control: CGPoint(x: w*0.6, y: h*0.5))
        
        // 中央垂直裝飾
        path.move(to: CGPoint(x: w/2, y: h*0.2))
        path.addLine(to: CGPoint(x: w/2, y: h*0.8))
        
        return path
    }
}

// 3. 內部裝飾填色形狀
struct KavehInnerDetailShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        // 繪製中間的一個菱形區域
        path.move(to: CGPoint(x: w/2, y: h*0.4))
        path.addLine(to: CGPoint(x: w*0.7, y: h*0.7))
        path.addLine(to: CGPoint(x: w/2, y: h*0.9))
        path.addLine(to: CGPoint(x: w*0.3, y: h*0.7))
        path.closeSubpath()
        return path
    }
}

// 4. 複雜羽毛筆形狀
struct KavehFeatherShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        // 左側羽毛邊緣 (帶缺口)
        path.move(to: CGPoint(x: w/2, y: 0))
        path.addCurve(to: CGPoint(x: 0, y: h*0.6),
                      control1: CGPoint(x: w*0.1, y: h*0.1),
                      control2: CGPoint(x: 0, y: h*0.4))
        // 缺口
        path.addLine(to: CGPoint(x: w*0.2, y: h*0.55))
        path.addLine(to: CGPoint(x: w*0.1, y: h*0.7))
        path.addQuadCurve(to: CGPoint(x: w/2, y: h), control: CGPoint(x: w*0.2, y: h*0.9))
        
        // 右側羽毛邊緣 (較平滑)
        path.move(to: CGPoint(x: w/2, y: 0))
        path.addCurve(to: CGPoint(x: w, y: h*0.6),
                      control1: CGPoint(x: w*0.9, y: h*0.1),
                      control2: CGPoint(x: w, y: h*0.4))
        path.addQuadCurve(to: CGPoint(x: w/2, y: h), control: CGPoint(x: w*0.8, y: h*0.9))
        
        path.closeSubpath()
        return path
    }
}

// 羽毛紋理層 (模擬真實羽毛的細密羽枝)
struct FeatherBarbTextureShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        // 羽枝的密度 (數字越大越密)
        let density = 80
        
        for i in 0...density {
            // 計算當前線條在Y軸的位置
            let yProgress = CGFloat(i) / CGFloat(density)
            let yPos = h * yProgress
            
            // 根據羽毛形狀調整線條長度 (中間寬，兩頭窄)
            // 使用 sin 函數來模擬這種弧度變化
            let widthFactor = sin(yProgress * .pi)
            
            // 計算隨機的微小角度變化，讓羽毛看起來更自然、不那麼死板
            let randomWobble = CGFloat.random(in: -2...2)
            
            // --- 左側羽枝 ---
            path.move(to: CGPoint(x: w/2, y: yPos))
            // 線條往左上方斜著長
            path.addLine(to: CGPoint(x: (w/2) - (w * 0.45 * widthFactor),
                                     y: yPos - 5 + randomWobble))
            
            // --- 右側羽枝 ---
            path.move(to: CGPoint(x: w/2, y: yPos))
            // 線條往右上方斜著長
            path.addLine(to: CGPoint(x: (w/2) + (w * 0.45 * widthFactor),
                                     y: yPos - 5 - randomWobble))
        }
        
        return path
    }
}

// 5. 筆尖形狀
struct KavehPenNibShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: w, y: 0))
        path.addLine(to: CGPoint(x: w/2, y: h)) // 尖端
        path.closeSubpath()
        
        // 墨水槽圓孔
        let holePath = Path(ellipseIn: CGRect(x: w*0.3, y: h*0.2, width: w*0.4, height: w*0.4))
        path.addPath(holePath)
        
        return path
    }
}

// 6. 頂部裝飾紋 (捲草紋)
struct KavehTopDecorationShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addQuadCurve(to: CGPoint(x: w, y: h), control: CGPoint(x: w*0.5, y: 0))
        path.addLine(to: CGPoint(x: 0, y: h))
        path.closeSubpath()
        return path
    }
}

#Preview {
    ContentView()
}
