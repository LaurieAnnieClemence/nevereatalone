module ApplicationHelper
  def title(string)
    content_for(:title, string)
  end

  def fa(name, **options)
    icon("fas", name, **options)
  end

  def user_image_for(user, **options)
    if user.image.attached?
      image_tag(user.image, **options)
    else
      image_tag("user.svg", **options)
    end
  end

  def render_or_none(collection, none: "Aucun")
    if collection.any?
      render(collection)
    else
      content_tag(:p, none, class: "mb-4")
    end
  end

  def count_for(collection, one:, other:, **options)
    if collection.any?
      if collection.size == 1
        content_tag(:p, one, **options)
      else
        content_tag(:p, "#{collection.size} #{other}", **options)
      end
    end
  end
end
