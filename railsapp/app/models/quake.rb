class Quake < ApplicationRecord
  belongs_to :device
  P_THRESH = 0 # P波の検出下限
  S_THRESH = 0 # S波の検出下限
  N_THRESH = 3 # 10分以内にこの回数以上の振動を検知した場合、地震発生とみなす

  # Return true if receives certain alerts more than 3 times in 10 minites.
  def self.happen?(now)
    t_border = (now || Time.now) - 10.minute
    n = Quake.where("p > #{P_THRESH} and s > #{S_THRESH} and created_at > '#{t_border}'").count
    return n >= N_THRESH
  end
end
