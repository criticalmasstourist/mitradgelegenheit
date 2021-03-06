class Track < ActiveRecord::Base
  has_many :track_points, dependent: :destroy, autosave: true
  has_many :starts, dependent: :destroy, autosave: true
  has_many :ends, dependent: :destroy, autosave: true
  has_many :start_times, dependent: :destroy, autosave: true

  scope :active, -> { joins { start_times }.where { (start_times.date == nil) | (start_times.date >= Date.today) }.group{id} }

  after_initialize :init

  accepts_nested_attributes_for :start_times
  accepts_nested_attributes_for :starts
  accepts_nested_attributes_for :ends

  validates :name, presence: true

  attr_reader :points

  def init
    self.color_index ||= rand * Track.colors.size
  end

  def points_list
    track_points.map(&:to_coordinates)
  end

  def start
    starts.order(:time).first
  end

  def color
    Track.colors[color_index % Track.colors.size]
  end

  def self.colors
    ['red', '#D91E18', '#96281B', '#2574A9', '#1E824C', '#F89406', '#6C7A89',
     '#22313F', '#2ECC71']
  end

  def compute_length
    sum = 0.0
    points_list.each_with_index do |coord, i|
      next if i == 0
      sum += Geocoder::Calculations.distance_between(points_list[i - 1], coord)
    end
    update_column :distance, sum
  end

  def add_track_points(track_point_params)
    track_points.delete_all
    on_points(track_point_params) {|point| track_points.create! point }
    compute_length
  end

  def on_points(points)
    points.split(';').each_with_index do |point, i|
      point = point.split(',')
      yield latitude: point[0].to_f,
            longitude: point[1].to_f,
            index: i
    end
  end
end
