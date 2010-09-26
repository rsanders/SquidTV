require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class EpisodeSpecTest < ActiveSupport::TestCase

  CASES = [
            ["Law.and.Order.S20E20.HDTV.XviD-LOL.avi", "Law and Order", 20, 20],
            ["24.S08E03.600PM-700PM.HDTV.XviD-FQM.avi", "24", 8, 3, "600 Pm 700 Pm"],
            ["The.Good.Wife.S01E07.Unorthodox.HDTV.XviD-FQM.[VTV].avi", "The Good Wife", 1, 7, "Unorthodox"],
            ["sherlock.1x03.the_great_game.hdtv_xvid-fov.avi", "Sherlock", 1, 3, "The Great Game"],
            ["Misfits S01E01.avi", "Misfits", 1, 1],
            ["louie.s01e02.720p.hdtv.x264-ctu.mkv", "Louie", 1, 2],
            ["Aqua Teen Hunger Force - S06E05 - Creature_From_Plaque_Lagoon.avi", "Aqua Teen Hunger Force", 6, 5, "Creature From Plaque Lagoon"],
            ["105 The IT Crowd.avi", "The IT Crowd", 1, 5],
            ["Breaking.Bad.S03E02.Caballo.Sin.Nombre.HDTV.XviD-FQM.avi", "Breaking Bad", 3, 2, "Caballo Sin Nombre"],
            ["Secret Diary of a Call Girl S01 E04  WS Xvid DVD Rip.avi", "Secret Diary of a Call Girl", 1, 4],
            ["The Dresden Files.S01E04-Rules of Engagement.avi", "The Dresden Files", 1, 4, "Rules Of Engagement"],
            ["Futurama.S06E07.The.Late.Philip.J.Fry.HDTV.XviD-FQM.[VTV].avi", "Futurama", 6, 7, "The Late Philip J Fry"],
            ["Warehouse.13.S02E10.Where.and.When.HDTV.XviD-FQM.[VTV].avi", "Warehouse 13", 2, 10, "Where And When"],
            ["The Venture Bros - S04E06 - Self-Medication [XviD HDTV] [2HD].avi", "The Venture Bros", 4, 6, "Self-Medication"],
            ["Bored.To.Death.S01E02.READNFO.DVDSCR.XviD-FFNDVD.avi", "Bored To Death", 1, 2, ""],
            ["Leverage.S03E12.The.King.George.Job.HDTV.XviD-FQM.avi", "Leverage", 3, 12, "The King George Job"]
  ]

  def chk(file, series, season, number, title = nil)
    es = EpisodeSpec.parse_filename(file)

    assert series.downcase == es.series.downcase, "#{file}, series=#{series}, got #{es.series}"
    assert season == es.season, "#{file}, season=#{season}, got #{es.season}"
    assert number == es.episode, "#{file}, number=#{number}, got #{es.episode}"
    assert title.titleize == es.title.titleize, "#{file}, title=#{title}, got #{es.title}" if title
  end

  # Replace this with your real tests.
  CASES.each do |bits|
    test "Parsing #{bits[0]}" do
      chk(*bits)
    end
  end
end
