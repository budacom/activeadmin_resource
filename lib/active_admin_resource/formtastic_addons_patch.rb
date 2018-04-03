module FormtasticAddonsExtensions
  def seems_searchable?
    return false
  end

  def klass
    @object.try(:object).try(:klass)
  end

  def ransacker?
    klass.try(:_ransackers).try(:key?, method.to_s)
  end

  def scope?
    context = Ransack::Context.for klass rescue nil
    context.respond_to?(:ransackable_scope?) && context.ransackable_scope?(method.to_s, klass)
  end
end
