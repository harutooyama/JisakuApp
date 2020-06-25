import UIKit

var str = "Hello, playground"

var number = 10 + 20
//Playground - noun: a place where people can play
/*
 Playground - noun:
 a place where people can play
 */

str = "I love Swift"

var x = 50
var y = 70
x + y
x - y
x * y
x / y

var int1:Int = 10
var double1 = Double(int1) + 0.5
var int2 = Int(double1)
var string1 = String(int2)

var int3 = Int(string1)
int3! + 10

var int4:Int? = 10
var string2:String? = "301"
Int(string2!)!  + 30

var score = 0
var str1 = "あなたのスコアは\(score)点です"


var strsdfa = "H,E,L,L,O"
strsdfa.lowercased()
strsdfa.count
strsdfa.components(separatedBy:",")
var adDic:[String:String] = ["国":"日本","都道府県":"神奈川県","市町村":"横浜"]
adDic["国"]

var strArray = ["google","apple","facebook"]
strArray.removeFirst()

var scoreDic = ["国語":61,"算数":55,"英語":80]
scoreDic["国語"]

var math = scoreDic["算数"]
var eng = scoreDic["英語"]
var lang = scoreDic["国語"]

(math! + eng! + lang!)/3

scoreDic.removeValue(forKey: "国語")
scoreDic["国語"]
scoreDic["国語"] = 100
scoreDic["化学"] = 88
scoreDic



var user: [String: Any] = [
    "sex": "man",
    "age": 28,
    "place": "tokyo"
]
user.updateValue(28,forKey:"place")
user.updateValue(39,forKey:"sfsfsfs")

var boolValue = true
var ret1 = boolValue ? "a" : "b"    // ret1 = "a"
var ret2 = !boolValue ? "a" : "b"   // ret2 = "b"

var stringValue : String? = "hogehoge" // Optional型
var ret = (stringValue != nil) ? "a" : "b" // ret = "a"
stringValue = nil
var dret2 = (stringValue != nil) ? "a" : "b" // ret = "b"

var rets = (stringValue == nil) ? "ok" : "ng"

var ssfscore = 70
switch ssfscore {
  case 100:
    print("100です。")
  case 70:
    print("70です。")
  case 40:
    print("40です。")
default:
  print("その他の値")
}

var count = 0

while count>10{
    count+=1
}
print(count)

for count in 0..<10{
    print(count)
}
var list = [2,3,4,5,6,7,8,3,98765,4,2]
for a in list{
    print(a)
}

