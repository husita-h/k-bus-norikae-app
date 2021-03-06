class BusStop < ApplicationRecord
  has_many :jikan

  OJI_ROUTE = %w[
    JR王子駅1
    王子本町交番
    障害者福祉センター
    中央図書館
    王子アパート
    紅葉橋
    北区役所
    飛鳥山公園1
    一里塚1
    花と森の東京病院1
    旧古河庭園1
    滝野川小学校1
    霜降橋1
    JR駒込駅
    霜降橋2
    滝野川小学校2
    旧古河庭園2
    花と森の東京病院2
    一里塚2
    飛鳥山公園2
    JR王子駅2
  ].freeze

  TABATA_ROUTE = %w[
    JR駒込駅
    駒込一丁目
    田端三丁目
    田端区民センター
    田端二丁目
    JR田端駅
    田端五丁目
    富士見橋エコー広場館
    中里保育園
    女子聖学院
    滝野川会館
    滝野川小学校
    霜降橋
    JR駒込駅
  ].freeze

  RELAY_POINT = {
    up: %w[
      JR駒込駅
      JR駒込駅
    ],
    down: %w[
      滝野川会館
      旧古河庭園2
    ]
  }.freeze

  def self.calculate_wait_time(on, off)
    get_on             = on
    get_off            = off
    get_on_bus_stop_id = BusStop.find_by(name: get_on)&.id
    # binding.pry
    if norikae?(get_on, get_off)
      binding.pry
      up = { up: up?(get_on) }
      Jikan.call_calculate_wait_time(get_on_bus_stop_id, up)
    else
      Jikan.non_wait_time(get_on_bus_stop_id)
    end
  end

  private

  def norikae?(get_on, get_off)
    binding.pry
    OJI_ROUTE.include?(get_on) && OJI_ROUTE.include?(get_off) ? false : true
  end

  def up?(get_on)
    OJI_ROUTE.include?(get_on) ? true : false
  end
end
