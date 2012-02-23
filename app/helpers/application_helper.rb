module ApplicationHelper
  def javascript(*args)
    content_for :head, javascript_include_tag(*args)
  end

  def title
    content_for?(:title) ? content_for(:title) : t(:app_title)
  end

  def meta_description
    content_for?(:meta_description) ? content_for(:meta_description) : t(:meta_description)
  end

  def render_establishment_partial(establishment)
    case establishment.source
      when 'toronto'
        render :partial => 'toronto'
      when 'montreal'
        render :partial => 'montreal'
      when 'vancouver'
        render :partial => 'vancouver'
    end
  end

  # icons from http://code.google.com/p/google-maps-icons/
  def establishments_json(establishments)
    establishments.select{|e| e.geocoded?}.map do |establishment|
      infraction = establishment.infractions.first
      {
        :id     => establishment.id,
        :lat    => establishment.latitude,
        :lng    => establishment.longitude,
        :name   => establishment.name,
        :url    => url_for(establishment),
        :count  => establishment.infractions_count,
        :amount => number_to_currency(establishment.infractions_amount),
        :latest => {
          :date   => l(infraction.judgment_date),
          :amount => number_to_currency(infraction.amount),
        },
      }
    end.to_json
  end

  def map_translations_json
    {
      :total_infractions => t(:total_infractions),
      :latest_infraction => t(:latest_infraction)
    }.to_json
  end

end
