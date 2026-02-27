import Foundation

struct Vocabulary: Identifiable, Codable{
    let object: String
    let hanzi: String
    let pinyin: String
    let english: String
    var isCollected: Bool = false
    
    var id: String {object} //make id = object
    
    private enum CodingKeys: String, CodingKey { //to match keys in json
        case object, hanzi, pinyin, english, isCollected
    }
    
    //to read words from a JSON file automatically
    init(from decoder: Decoder) throws {
           let container = try decoder.container(keyedBy: CodingKeys.self)
           self.object = try container.decode(String.self, forKey: .object)
           self.hanzi = try container.decode(String.self, forKey: .hanzi)
           self.pinyin = try container.decode(String.self, forKey: .pinyin)
           self.english = try container.decode(String.self, forKey: .english)
           // Default to false if isCollected is missing in JSON
           self.isCollected = try container.decodeIfPresent(Bool.self, forKey: .isCollected) ?? false
       }
}

extension Vocabulary {
    static let quickSelectObjects: [String] = [
        "person", "dog", "cat",
        "book", "cup", "cell phone",
        "chair", "table",
        "laptop",
        "tree", "flower",
        "car", "bicycle",
        "apple", "banana"
    ]
}

extension Vocabulary {
    static let vocabularyJSON = """
        {
          "vocabulary": [
            {"hanzi": "人", "pinyin": "rén", "english": "person", "object": "person"},
            {"hanzi": "男人", "pinyin": "nánrén", "english": "man", "object": "man"},
            {"hanzi": "女人", "pinyin": "nǚrén", "english": "woman", "object": "woman"},
            {"hanzi": "孩子", "pinyin": "háizi", "english": "child", "object": "child"},
            {"hanzi": "狗", "pinyin": "gǒu", "english": "dog", "object": "dog"},
            {"hanzi": "猫", "pinyin": "māo", "english": "cat", "object": "cat"},
            {"hanzi": "鸟", "pinyin": "niǎo", "english": "bird", "object": "bird"},
            {"hanzi": "鱼", "pinyin": "yú", "english": "fish", "object": "fish"},
            {"hanzi": "马", "pinyin": "mǎ", "english": "horse", "object": "horse"},
            {"hanzi": "羊", "pinyin": "yáng", "english": "sheep", "object": "sheep"},
            {"hanzi": "牛", "pinyin": "niú", "english": "cow", "object": "cow"},
            {"hanzi": "猪", "pinyin": "zhū", "english": "pig", "object": "pig"},
            {"hanzi": "鸡", "pinyin": "jī", "english": "chicken", "object": "chicken"},
            {"hanzi": "熊", "pinyin": "xióng", "english": "bear", "object": "bear"},
            {"hanzi": "大象", "pinyin": "dàxiàng", "english": "elephant", "object": "elephant"},
            {"hanzi": "长颈鹿", "pinyin": "chángjǐnglù", "english": "giraffe", "object": "giraffe"},
            {"hanzi": "斑马", "pinyin": "bānmǎ", "english": "zebra", "object": "zebra"},
            {"hanzi": "椅子", "pinyin": "yǐzi", "english": "chair", "object": "chair"},
            {"hanzi": "桌子", "pinyin": "zhuōzi", "english": "table", "object": "table"},
            {"hanzi": "床", "pinyin": "chuáng", "english": "bed", "object": "bed"},
            {"hanzi": "沙发", "pinyin": "shāfā", "english": "sofa", "object": "couch"},
            {"hanzi": "书架", "pinyin": "shūjià", "english": "bookshelf", "object": "bookshelf"},
            {"hanzi": "柜子", "pinyin": "guìzi", "english": "cabinet", "object": "cabinet"},
            {"hanzi": "抽屉", "pinyin": "chōuti", "english": "drawer", "object": "drawer"},
            {"hanzi": "衣柜", "pinyin": "yīguì", "english": "wardrobe", "object": "wardrobe"},
            {"hanzi": "电视", "pinyin": "diànshì", "english": "television", "object": "tv"},
            {"hanzi": "电脑", "pinyin": "diànnǎo", "english": "computer", "object": "laptop"},
            {"hanzi": "手机", "pinyin": "shǒujī", "english": "mobile phone", "object": "cell phone"},
            {"hanzi": "键盘", "pinyin": "jiànpán", "english": "keyboard", "object": "keyboard"},
            {"hanzi": "鼠标", "pinyin": "shǔbiāo", "english": "mouse", "object": "mouse"},
            {"hanzi": "遥控器", "pinyin": "yáokòngqì", "english": "remote control", "object": "remote"},
            {"hanzi": "相机", "pinyin": "xiàngjī", "english": "camera", "object": "camera"},
            {"hanzi": "耳机", "pinyin": "ěrjī", "english": "headphones", "object": "headphones"},
            {"hanzi": "音箱", "pinyin": "yīnxiāng", "english": "speaker", "object": "speaker"},
            {"hanzi": "杯子", "pinyin": "bēizi", "english": "cup", "object": "cup"},
            {"hanzi": "瓶子", "pinyin": "píngzi", "english": "bottle", "object": "bottle"},
            {"hanzi": "碗", "pinyin": "wǎn", "english": "bowl", "object": "bowl"},
            {"hanzi": "盘子", "pinyin": "pánzi", "english": "plate", "object": "plate"},
            {"hanzi": "勺子", "pinyin": "sháozi", "english": "spoon", "object": "spoon"},
            {"hanzi": "叉子", "pinyin": "chāzi", "english": "fork", "object": "fork"},
            {"hanzi": "刀", "pinyin": "dāo", "english": "knife", "object": "knife"},
            {"hanzi": "筷子", "pinyin": "kuàizi", "english": "chopsticks", "object": "chopsticks"},
            {"hanzi": "茶杯", "pinyin": "chábēi", "english": "teacup", "object": "teacup"},
            {"hanzi": "水壶", "pinyin": "shuǐhú", "english": "kettle", "object": "kettle"},
            {"hanzi": "锅", "pinyin": "guō", "english": "pot", "object": "pot"},
            {"hanzi": "平底锅", "pinyin": "píngdǐguō", "english": "pan", "object": "pan"},
            {"hanzi": "冰箱", "pinyin": "bīngxiāng", "english": "refrigerator", "object": "refrigerator"},
            {"hanzi": "微波炉", "pinyin": "wēibōlú", "english": "microwave", "object": "microwave"},
            {"hanzi": "烤箱", "pinyin": "kǎoxiāng", "english": "oven", "object": "oven"},
            {"hanzi": "洗衣机", "pinyin": "xǐyījī", "english": "washing machine", "object": "washing machine"},
            {"hanzi": "苹果", "pinyin": "píngguǒ", "english": "apple", "object": "apple"},
            {"hanzi": "香蕉", "pinyin": "xiāngjiāo", "english": "banana", "object": "banana"},
            {"hanzi": "橙子", "pinyin": "chéngzi", "english": "orange", "object": "orange"},
            {"hanzi": "梨", "pinyin": "lí", "english": "pear", "object": "pear"},
            {"hanzi": "西瓜", "pinyin": "xīguā", "english": "watermelon", "object": "watermelon"},
            {"hanzi": "草莓", "pinyin": "cǎoméi", "english": "strawberry", "object": "strawberry"},
            {"hanzi": "葡萄", "pinyin": "pútáo", "english": "grape", "object": "grape"},
            {"hanzi": "桃子", "pinyin": "táozi", "english": "peach", "object": "peach"},
            {"hanzi": "蛋糕", "pinyin": "dàngāo", "english": "cake", "object": "cake"},
            {"hanzi": "面包", "pinyin": "miànbāo", "english": "bread", "object": "bread"},
            {"hanzi": "饼干", "pinyin": "bǐnggān", "english": "cookie", "object": "cookie"},
            {"hanzi": "披萨", "pinyin": "pīsà", "english": "pizza", "object": "pizza"},
            {"hanzi": "三明治", "pinyin": "sānmíngzhì", "english": "sandwich", "object": "sandwich"},
            {"hanzi": "热狗", "pinyin": "règǒu", "english": "hot dog", "object": "hot dog"},
            {"hanzi": "汉堡", "pinyin": "hànbǎo", "english": "hamburger", "object": "hamburger"},
            {"hanzi": "甜甜圈", "pinyin": "tiántiánquān", "english": "donut", "object": "donut"},
            {"hanzi": "米饭", "pinyin": "mǐfàn", "english": "rice", "object": "rice"},
            {"hanzi": "面条", "pinyin": "miàntiáo", "english": "noodles", "object": "noodles"},
            {"hanzi": "鸡蛋", "pinyin": "jīdàn", "english": "egg", "object": "egg"},
            {"hanzi": "牛奶", "pinyin": "niúnǎi", "english": "milk", "object": "milk"},
            {"hanzi": "水", "pinyin": "shuǐ", "english": "water", "object": "water"},
            {"hanzi": "茶", "pinyin": "chá", "english": "tea", "object": "tea"},
            {"hanzi": "咖啡", "pinyin": "kāfēi", "english": "coffee", "object": "coffee"},
            {"hanzi": "果汁", "pinyin": "guǒzhī", "english": "juice", "object": "juice"},
            {"hanzi": "车", "pinyin": "chē", "english": "car", "object": "car"},
            {"hanzi": "自行车", "pinyin": "zìxíngchē", "english": "bicycle", "object": "bicycle"},
            {"hanzi": "摩托车", "pinyin": "mótuōchē", "english": "motorcycle", "object": "motorcycle"},
            {"hanzi": "公交车", "pinyin": "gōngjiāochē", "english": "bus", "object": "bus"},
            {"hanzi": "出租车", "pinyin": "chūzūchē", "english": "taxi", "object": "taxi"},
            {"hanzi": "火车", "pinyin": "huǒchē", "english": "train", "object": "train"},
            {"hanzi": "飞机", "pinyin": "fēijī", "english": "airplane", "object": "airplane"},
            {"hanzi": "船", "pinyin": "chuán", "english": "boat", "object": "boat"},
            {"hanzi": "书", "pinyin": "shū", "english": "book", "object": "book"},
            {"hanzi": "笔", "pinyin": "bǐ", "english": "pen", "object": "pen"},
            {"hanzi": "铅笔", "pinyin": "qiānbǐ", "english": "pencil", "object": "pencil"},
            {"hanzi": "橡皮", "pinyin": "xiàngpí", "english": "eraser", "object": "eraser"},
            {"hanzi": "尺子", "pinyin": "chǐzi", "english": "ruler", "object": "ruler"},
            {"hanzi": "笔记本", "pinyin": "bǐjìběn", "english": "notebook", "object": "notebook"},
            {"hanzi": "纸", "pinyin": "zhǐ", "english": "paper", "object": "paper"},
            {"hanzi": "包", "pinyin": "bāo", "english": "bag", "object": "backpack"},
            {"hanzi": "书包", "pinyin": "shūbāo", "english": "school bag", "object": "school bag"},
            {"hanzi": "手提包", "pinyin": "shǒutíbāo", "english": "handbag", "object": "handbag"},
            {"hanzi": "钱包", "pinyin": "qiánbāo", "english": "wallet", "object": "wallet"},
            {"hanzi": "雨伞", "pinyin": "yǔsǎn", "english": "umbrella", "object": "umbrella"},
            {"hanzi": "帽子", "pinyin": "màozi", "english": "hat", "object": "hat"},
            {"hanzi": "眼镜", "pinyin": "yǎnjìng", "english": "glasses", "object": "eyeglasses"},
            {"hanzi": "太阳镜", "pinyin": "tàiyángjìng", "english": "sunglasses", "object": "sunglasses"},
            {"hanzi": "手表", "pinyin": "shǒubiǎo", "english": "watch", "object": "watch"},
            {"hanzi": "鞋", "pinyin": "xié", "english": "shoe", "object": "shoe"},
            {"hanzi": "袜子", "pinyin": "wàzi", "english": "sock", "object": "sock"},
            {"hanzi": "衣服", "pinyin": "yīfu", "english": "clothes", "object": "clothes"},
            {"hanzi": "裤子", "pinyin": "kùzi", "english": "pants", "object": "pants"},
            {"hanzi": "裙子", "pinyin": "qúnzi", "english": "skirt", "object": "skirt"},
            {"hanzi": "外套", "pinyin": "wàitào", "english": "coat", "object": "coat"},
            {"hanzi": "围巾", "pinyin": "wéijīn", "english": "scarf", "object": "scarf"},
            {"hanzi": "领带", "pinyin": "lǐngdài", "english": "necktie", "object": "tie"},
            {"hanzi": "手套", "pinyin": "shǒutào", "english": "gloves", "object": "glove"},
            {"hanzi": "树", "pinyin": "shù", "english": "tree", "object": "tree"},
            {"hanzi": "花", "pinyin": "huā", "english": "flower", "object": "flower"},
            {"hanzi": "草", "pinyin": "cǎo", "english": "grass", "object": "grass"},
            {"hanzi": "叶子", "pinyin": "yèzi", "english": "leaf", "object": "leaf"},
            {"hanzi": "盆栽", "pinyin": "pénzāi", "english": "potted plant", "object": "potted plant"},
            {"hanzi": "门", "pinyin": "mén", "english": "door", "object": "door"},
            {"hanzi": "窗户", "pinyin": "chuānghu", "english": "window", "object": "window"},
            {"hanzi": "墙", "pinyin": "qiáng", "english": "wall", "object": "wall"},
            {"hanzi": "地板", "pinyin": "dìbǎn", "english": "floor", "object": "floor"},
            {"hanzi": "天花板", "pinyin": "tiānhuābǎn", "english": "ceiling", "object": "ceiling"},
            {"hanzi": "楼梯", "pinyin": "lóutī", "english": "stairs", "object": "stairs"},
            {"hanzi": "电梯", "pinyin": "diàntī", "english": "elevator", "object": "elevator"},
            {"hanzi": "钟", "pinyin": "zhōng", "english": "clock", "object": "clock"},
            {"hanzi": "闹钟", "pinyin": "nàozhōng", "english": "alarm clock", "object": "alarm clock"},
            {"hanzi": "镜子", "pinyin": "jìngzi", "english": "mirror", "object": "mirror"},
            {"hanzi": "照片", "pinyin": "zhàopiàn", "english": "photo", "object": "photo"},
            {"hanzi": "画", "pinyin": "huà", "english": "painting", "object": "painting"},
            {"hanzi": "花瓶", "pinyin": "huāpíng", "english": "vase", "object": "vase"},
            {"hanzi": "蜡烛", "pinyin": "làzhú", "english": "candle", "object": "candle"},
            {"hanzi": "灯", "pinyin": "dēng", "english": "lamp", "object": "lamp"},
            {"hanzi": "台灯", "pinyin": "táidēng", "english": "desk lamp", "object": "desk lamp"},
            {"hanzi": "剪刀", "pinyin": "jiǎndāo", "english": "scissors", "object": "scissors"},
            {"hanzi": "刷子", "pinyin": "shuāzi", "english": "brush", "object": "brush"},
            {"hanzi": "牙刷", "pinyin": "yáshuā", "english": "toothbrush", "object": "toothbrush"},
            {"hanzi": "梳子", "pinyin": "shūzi", "english": "comb", "object": "comb"},
            {"hanzi": "毛巾", "pinyin": "máojīn", "english": "towel", "object": "towel"},
            {"hanzi": "香皂", "pinyin": "xiāngzào", "english": "soap", "object": "soap"},
            {"hanzi": "吹风机", "pinyin": "chuīfēngjī", "english": "hair dryer", "object": "hair dryer"},
            {"hanzi": "球", "pinyin": "qiú", "english": "ball", "object": "ball"},
            {"hanzi": "足球", "pinyin": "zúqiú", "english": "soccer ball", "object": "soccer ball"},
            {"hanzi": "篮球", "pinyin": "lánqiú", "english": "basketball", "object": "basketball"},
            {"hanzi": "网球", "pinyin": "wǎngqiú", "english": "tennis ball", "object": "tennis ball"},
            {"hanzi": "网球拍", "pinyin": "wǎngqiúpāi", "english": "tennis racket", "object": "tennis racket"},
            {"hanzi": "滑板", "pinyin": "huábǎn", "english": "skateboard", "object": "skateboard"},
            {"hanzi": "冲浪板", "pinyin": "chōnglàngbǎn", "english": "surfboard", "object": "surfboard"},
            {"hanzi": "风筝", "pinyin": "fēngzheng", "english": "kite", "object": "kite"},
            {"hanzi": "玩具", "pinyin": "wánjù", "english": "toy", "object": "toy"},
            {"hanzi": "泰迪熊", "pinyin": "tàidíxióng", "english": "teddy bear", "object": "teddy bear"},
            {"hanzi": "红绿灯", "pinyin": "hónglǜdēng", "english": "traffic light", "object": "traffic light"},
            {"hanzi": "消防栓", "pinyin": "xiāofángshuan", "english": "fire hydrant", "object": "fire hydrant"},
            {"hanzi": "停车标志", "pinyin": "tíngchē biāozhì", "english": "stop sign", "object": "stop sign"},
            {"hanzi": "停车计时器", "pinyin": "tíngchē jìshíqì", "english": "parking meter", "object": "parking meter"},
            {"hanzi": "长凳", "pinyin": "chángdèng", "english": "bench", "object": "bench"},
            {"hanzi": "垃圾桶", "pinyin": "lājītǒng", "english": "trash can", "object": "trash can"}
          ]
        }
        
        """
}
