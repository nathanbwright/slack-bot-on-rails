# frozen_string_literal: true

RSpec.describe ListThreadLinksJob do
  let(:event) { FactoryBot.build_stubbed(:slack_event) }
  let(:persisted) { true }

  before do
    expect(SlackEvent).to receive(:find).with(event.id) { event }
    expect(event).to receive(:update).with(state: 'replied')
    expect(SlackThread).to receive(:find_or_initialize_by).with(slack_ts: event.thread_ts) { thread }
    allow(thread).to receive(:persisted?).and_return(persisted)
    allow(thread).to receive(:post_message)
    ListThreadLinksJob.run(event_id: event.id)
  end

  context 'no categories' do
    let(:thread) { FactoryBot.build_stubbed(:slack_thread) }

    it 'replies "none"' do
      expect(thread).to have_received(:post_message).with(/none/i)
    end
  end

  context 'categories' do
    let(:thread) { FactoryBot.build_stubbed(:slack_thread, :links) }

    it 'replies with categories' do
      expect(thread).to have_received(:post_message).with(/#{thread.category_list}/)
    end
  end

  context 'thread not found' do
    let(:persisted) { false }
    let(:thread) { FactoryBot.build_stubbed(:slack_thread) }

    it 'replies "not tracking"' do
      expect(thread).to have_received(:post_message).with(/not tracking/)
    end
  end
end