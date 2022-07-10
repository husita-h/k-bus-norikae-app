OJI_ROUTE = [
  ['JR王子駅1', false],
  ['王子本町交番', false],
  ['障害者福祉センター', false],
  ['中央図書館', false],
  ['王子アパート', false],
  ['紅葉橋', false],
  ['北区役所', false],
  ['飛鳥山公園1', false],
  ['一里塚1', false],
  ['花と森の東京病院1', false],
  ['旧古河庭園1', false],
  ['滝野川小学校1', false],
  ['霜降橋1', false],
  ['JR駒込駅', true],
  ['霜降橋2', false],
  ['滝野川小学校2', false],
  ['旧古河庭園2', true],
  ['花と森の東京病院2', false],
  ['一里塚2', false],
  ['飛鳥山公園2', false],
  ['JR王子駅2', false]
]

TABATA_ROUTE = [
  ['JR駒込駅', true],
  ['駒込一丁目', false],
  ['田端三丁目', false],
  ['田端区民センター', false],
  ['田端二丁目', false],
  ['JR田端駅', false],
  ['田端五丁目', false],
  ['富士見橋エコー広場館', false],
  ['中里保育園', false],
  ['女子聖学院', false],
  ['滝野川会館', true],
  ['滝野川小学校', false],
  ['霜降橋', false]
]

MAIJI_LIST_OJI = [
  [15, 35, 55],
  [16, 36, 55], # ここまで正しい
  [16, 36, 55],
  [16, 36, 55],
  [16, 36, 55],
  [16, 36, 55],
  [16, 36, 55],
  [16, 36, 55],
  [16, 36, 55],
  [16, 36, 55],
  [16, 36, 55],
  [16, 36, 55],
  [16, 36, 55],
  [16, 36, 55],
  [16, 36, 55],
  [16, 36, 55],
  [16, 36, 55],
  [16, 36, 55],
  [16, 36, 55],
  [16, 36, 55],
  [16, 36, 55]
]

MAIJI_LIST_TABATA = [
  [15, 35, 55], # JR駒込駅
  [16, 36, 55], # 王子本町交番 ...
  [16, 36, 55], 
  [16, 36, 55], 
  [16, 36, 55], 
  [16, 36, 55], 
  [16, 36, 55], 
  [16, 36, 55], 
  [16, 36, 55], 
  [16, 36, 55], 
  [16, 36, 55], 
  [16, 36, 55], 
  [16, 36, 55]
]

SIHATU_HOUR = 7
SAISHUU_HOUR = 19

def repeat_counts
  SAISHUU_HOUR - SIHATU_HOUR + 1
end

def zipping_list(staions, maiji_lists)
  # [['霜降橋', false, 55]こういう配列を返したい
  zipped = staions.zip(maiji_lists)
  # [[['霜降橋', false], [15, 35, 55]], [["hoge", true], [1, 5, 5]]]

  zipped.each_with_object([]) do |value, arg|
    station_set  = value[0]
    jikan_set = value[1]
    
    jikan_set.each do |v|
      station_set  = value[0]
      arg << station_set.push(v)
    end
  end
end

def create_jikokuhyo(zipped_lists)
  zipped_lists.each_with_index do |list, index|
    # [['霜降橋', false, 55], ..., ..., ]の形で受け取る
    name            = list[0]
    is_relay_point  = list[1]
    minute          = list[2]

    station = Station.create(
      name:           name,
      is_relay_point: is_relay_point
    )
    repeat_counts.times do |count|
      Jikan.create(
        station_id: station[:id],
        order:              index,
        get_on_time_hour:   count + 6, # 6を足すことで時間を指定する
        get_on_time_minute: minute,
        row:                count
      )
    end
  end
end

# ===
oji = zipping_list(OJI_ROUTE, MAIJI_LIST_OJI)
tabata = zipping_list(TABATA_ROUTE, MAIJI_LIST_TABATA)

create_jikokuhyo(oji)
create_jikokuhyo(tabata)
