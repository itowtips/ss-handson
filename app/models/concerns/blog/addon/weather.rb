module Blog::Addon
  module Weather
    extend ActiveSupport::Concern
    extend SS::Addon

    included do
      field :weather, type: String
      permit_params :weather

      public
        def weather_options
          [ ["晴れ", "sunny"], ["曇り", "cloudy"],
            ["雨", "rain"], ["雪", "snow"],
          ]
        end
    end
  end
end
