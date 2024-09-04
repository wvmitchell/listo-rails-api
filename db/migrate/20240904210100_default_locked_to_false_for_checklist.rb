class DefaultLockedToFalseForChecklist < ActiveRecord::Migration[7.2]
  def change
    change_column_default :checklists, :locked, from: nil, to: false
  end
end
