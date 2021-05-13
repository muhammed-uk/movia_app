module CacheHelper
  DEFAULT_EXPIRES_IN = 1.hour
  PROC_LIST = {
    'seat_id_number_mapping' => Proc.new do |show|
      Hash[show.all_seat_with_id_and_number]
    end,
    'occupied_seats' => Proc.new do |show|
      show.filled_seat_numbers
    end
  }

  def write_to_cache(cache_key, content)
    Rails.cache.write(cache_key, content, expires_in: DEFAULT_EXPIRES_IN)
  end

  def read_from_cache(cache_key)
    Rails.cache.read(cache_key)
  end

  def read_or_write(cache_key, sub_key, param)
    cached_content = read_from_cache(cache_key)
    if cached_content.present?
      if cached_content[sub_key].present?
        return cached_content[sub_key]
      else
        content = PROC_LIST[sub_key].call(param)
        cached_content[sub_key] = content
        write_to_cache(cache_key, cached_content)
        content
      end
    else
      new_content = PROC_LIST[sub_key].call(param)
      write_to_cache(cache_key, { sub_key => new_content })
      new_content
    end
  end
end