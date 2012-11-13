class AsciiaiController < ApplicationController

  def get
    all_ai = Asciiai.find(:all, :order => 'games_played ASC')
    if all_ai.length < 50
      (all_ai.length..50).each do |i|
        new_ai = Asciiai.new()
        ir_a = rand(100)
        ir_d = rand(100-ir_a)
        ir_p = 1 - ir_a - ir_d
        min_p = rand(10)
        attack_timing = rand(17940) + 60
        new_ai.ir_a = ir_a/100.0
        new_ai.ir_d = ir_d/100.0
        new_ai.ir_p = ir_p/100.0
        new_ai.min_p = min_p
        new_ai.attack_timing = attack_timing
        new_ai.games_played = 1
        new_ai.wins = 0
        new_ai.save()
      end
      all_ai = Asciiai.find(:all, :order => 'games_played ASC')
    end

    if all_ai.first.games_played == 10
      max = -1
      min = 11
      ave = 0
      all_ai.each do |ai|
        if ai.wins > max
          max = ai.wins
        elsif ai.wins < min
          min = ai.wins
        end
        ave = ave + ai.wins
      end
      ave = (ave / 1.0) / (all_ai.length / 1.0)
      all_ai.each do |ai|
        if ai.wins < ave
          Asciiai.find(ai.id).delete()
        else
          ai.games_played = 1
          ai.wins = 0
          ai.save()
        end
      end
      all_ai = Asciiai.find(:all, :order => 'games_played ASC')
      (all_ai.length..50).each do |i|
        mom = all_ai[rand(all_ai.length)]
        dad = all_ai[rand(all_ai.length)]
        new_ai = Asciiai.new()
        ir_a = [[(mom.ir_a + dad.ir_a)/2.0 + (rand(1000)/1000.0 - rand(1000)/1000.0)*0.01,1.0].min,0.0].max
        ir_d = [[(mom.ir_d + dad.ir_d)/2.0 + (rand(1000)/1000.0 - rand(1000)/1000.0)*0.01,1.0].min,0.0].max
        ir_p = [[(mom.ir_p + dad.ir_p)/2.0 + (rand(1000)/1000.0 - rand(1000)/1000.0)*0.01,1.0].min,0.0].max
        min_p = ((mom.min_p + dad.min_p)/2.0).floor + (rand(2) - rand(2))
        attack_timing = ((mom.attack_timing + dad.attack_timing)/2.0).floor + (rand(60)-rand(60))
        new_ai.ir_a = ir_a/100.0
        new_ai.ir_d = ir_d/100.0
        new_ai.ir_p = ir_p/100.0
        new_ai.min_p = min_p
        new_ai.attack_timing = attack_timing
        new_ai.games_played = 1
        new_ai.wins = 0
        new_ai.save()
      end
      all_ai = Asciiai.find(:all, :order => 'games_played ASC')
    end

    ai = all_ai.first
    render json: ai
  end

  def update
    ai = Asciiai.find(params[:id])
    if ai
      ai.games_played = ai.games_played + 1
      ai.wins = ai.wins + Integer(params[:win])
      ai.save()
    end
    render json: 'done'
  end
end
