class PrefCodes {
  static final Map<String, String> _prefMap = {
    "01": "北海道",
    "02": "青森",
    "03": "岩手",
    "04": "宮城",
    "05": "秋田",
    "06": "山形",
    "07": "福島",
    "08": "茨城",
    "09": "栃木",
    "10": "群馬",
    "11": "埼玉",
    "12": "千葉",
    "13": "東京",
    "14": "神奈川",
    "15": "新潟",
    "16": "富山",
    "17": "石川",
    "18": "福井",
    "19": "山梨",
    "20": "長野",
    "21": "岐阜",
    "22": "静岡",
    "23": "愛知",
    "24": "三重",
    "25": "滋賀",
    "26": "京都",
    "27": "大阪",
    "28": "兵庫",
    "29": "奈良",
    "30": "和歌山",
    "31": "鳥取",
    "32": "島根",
    "33": "岡山",
    "34": "広島",
    "35": "山口",
    "36": "徳島",
    "37": "香川",
    "38": "愛媛",
    "39": "高知",
    "40": "福岡",
    "41": "佐賀",
    "42": "長崎",
    "43": "熊本",
    "44": "大分",
    "45": "宮崎",
    "46": "鹿児島",
    "47": "沖縄",
  };

  static String cdToName(String cd) {
    if (_prefMap.containsKey(cd)) {
      return _prefMap[cd]!;
    }
    return "";
  }

  static String nameToCd(String name) {
    if (_prefMap.containsValue(name)) {
      var ret = "";
      _prefMap.forEach((String key, String value) {
        if (value == name) {
          ret = key;
        }
      });
      return ret;
    }
    return "";
  }
}
