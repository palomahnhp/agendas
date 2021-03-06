class StatisticsController < ApplicationController

  def index
    @lobbies_categories = Category.all.map { |c| [c.name, c.organizations.lobby.count] }.to_h
    @lobbies_interests = Interest.all.map { |i| [i.name, i.organizations.lobby.count] }.to_h
    @lobbies = Organization.lobby.active
    @active_agent_count = Agent.active.from_active_organizations.count
    @event_lobby_activity = Event.where("lobby_activity").count
    @events_count = Event.published.count
    @holders_count = Holder.count
  end

end
