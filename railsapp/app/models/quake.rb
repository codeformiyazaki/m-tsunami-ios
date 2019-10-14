class Quake < ApplicationRecord
  # Return true if receives certain alerts more than 3 times in 10 minites.
  def happen?
    p_thresh = 0
    s_thresh = 0
    t_border = Time.now - 10.minute
    n = Quake.where("p > #{p_thresh} and s > #{s_thresh} and created_at > '#{t_border}'").count
    return n >= 3
  end
end
