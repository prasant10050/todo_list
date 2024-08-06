abstract class Mapper<E, D> {
  D mapFromEntity(E entity);

  E mapToEntity(D dto);
}
