import 'package:todo_list_app/app/view/features/todo/bloc/todo_state.dart';

extension TodoStateX on TodoState {
  T map<T>({
    required T Function(TodoLoading) loading,
    required T Function(TodoProcessing) processing,
    required T Function(TodoEmpty) empty,
    required T Function(TodoFailure) error,
    required T Function(RemoveTodoState) remove,
    required T Function(RemoveAllTodoState) removeAll,
    required T Function(GetTodoState) getById,
    required T Function(YieldAllTodoState) yieldAllTodo,
    required T Function(AddTodoSuccess) addTodo,
    required T Function(UpdateTodoState) updateTodo,
    required T Function(MarkTodoState) markAsDone,
    required T Function(FilterTodoState) filterAll,
    required T Function(OpenAddTodoDialogState) openAddTodoDialog,
    required T Function(DiscardTodoDialogState) discardTodo,
    required T Function(OpenEditTodoDialogState) openEditTodoDialog,
    required T Function(ShowTodoDetailsState) todoDetails,
    required T Function() orElse,
  }) {
    if (this is TodoLoading) {
      return loading(this as TodoLoading);
    }
    //
    else if (this is TodoProcessing) {
      return processing(this as TodoProcessing);
    } else if (this is TodoFailure) {
      return error(this as TodoFailure);
    } else if (this is TodoEmpty) {
      return empty(this as TodoEmpty);
    } else if (this is RemoveTodoState) {
      return remove(this as RemoveTodoState);
    }
    //
    else if (this is RemoveAllTodoState) {
      return removeAll(this as RemoveAllTodoState);
    } else if (this is GetTodoState) {
      return getById(this as GetTodoState);
    } else if (this is YieldAllTodoState) {
      return yieldAllTodo(this as YieldAllTodoState);
    } else if (this is AddTodoSuccess) {
      return addTodo(this as AddTodoSuccess);
    } else if (this is UpdateTodoState) {
      return updateTodo(this as UpdateTodoState);
    } else if (this is MarkTodoState) {
      return markAsDone(this as MarkTodoState);
    } else if (this is FilterTodoState) {
      return filterAll(this as FilterTodoState);
    } else if (this is OpenAddTodoDialogState) {
      return openAddTodoDialog(this as OpenAddTodoDialogState);
    } else if (this is DiscardTodoDialogState) {
      return discardTodo(this as DiscardTodoDialogState);
    } else if (this is OpenEditTodoDialogState) {
      return openEditTodoDialog(this as OpenEditTodoDialogState);
    } else if (this is ShowTodoDetailsState) {
      return todoDetails(this as ShowTodoDetailsState);
    } else {
      return orElse();
    }
  }

  // mayBeMap
  T mayBeMap<T>({
    required T Function() orElse,
    T Function(TodoLoading)? loading,
    T Function(TodoProcessing)? processing,
    T Function(TodoEmpty)? empty,
    T Function(TodoFailure)? error,
    T Function(RemoveTodoState)? remove,
    T Function(RemoveAllTodoState)? removeAll,
    T Function(GetTodoState)? getById,
    T Function(YieldAllTodoState)? yieldAllTodo,
    T Function(AddTodoSuccess)? addTodo,
    T Function(UpdateTodoState)? updateTodo,
    T Function(MarkTodoState)? markAsDone,
    T Function(FilterTodoState)? filterAll,
    T Function(OpenAddTodoDialogState)? openAddTodoDialog,
    T Function(DiscardTodoDialogState)? discardTodo,
    T Function(OpenEditTodoDialogState)? openEditTodoDialog,
    T Function(ShowTodoDetailsState)? todoDetails,
  }) {
    if (this is TodoLoading) {
      return loading != null ? loading(this as TodoLoading) : orElse();
    } else if (this is TodoProcessing) {
      return processing != null ? processing(this as TodoProcessing) : orElse();
    } else if (this is TodoFailure) {
      return error != null ? error(this as TodoFailure) : orElse();
    } else if (this is TodoEmpty) {
      return empty != null ? empty(this as TodoEmpty) : orElse();
    } else if (this is RemoveTodoState) {
      return remove != null ? remove(this as RemoveTodoState) : orElse();
    } else if (this is RemoveAllTodoState) {
      return removeAll != null
          ? removeAll(this as RemoveAllTodoState)
          : orElse();
    } else if (this is GetTodoState) {
      return getById != null ? getById(this as GetTodoState) : orElse();
    } else if (this is YieldAllTodoState) {
      return yieldAllTodo != null
          ? yieldAllTodo(this as YieldAllTodoState)
          : orElse();
    } else if (this is AddTodoSuccess) {
      return addTodo != null ? addTodo(this as AddTodoSuccess) : orElse();
    } else if (this is UpdateTodoState) {
      return updateTodo != null
          ? updateTodo(this as UpdateTodoState)
          : orElse();
    } else if (this is MarkTodoState) {
      return markAsDone != null ? markAsDone(this as MarkTodoState) : orElse();
    } else if (this is FilterTodoState) {
      return filterAll != null ? filterAll(this as FilterTodoState) : orElse();
    } else if (this is OpenAddTodoDialogState) {
      return openAddTodoDialog != null
          ? openAddTodoDialog(this as OpenAddTodoDialogState)
          : orElse();
    } else if (this is DiscardTodoDialogState) {
      return discardTodo != null
          ? discardTodo(this as DiscardTodoDialogState)
          : orElse();
    } else if (this is OpenEditTodoDialogState) {
      return openEditTodoDialog != null
          ? openEditTodoDialog(this as OpenEditTodoDialogState)
          : orElse();
    } else if (this is ShowTodoDetailsState) {
      return todoDetails != null
          ? todoDetails(this as ShowTodoDetailsState)
          : orElse();
    } else {
      return orElse();
    }
  }

  T? mapOrNull<T>({
    T Function(TodoLoading)? loading,
    T Function(TodoProcessing)? processing,
    T Function(TodoEmpty)? empty,
    T Function(TodoFailure)? error,
    T Function(RemoveTodoState)? remove,
    T Function(RemoveAllTodoState)? removeAll,
    T Function(GetTodoState)? getById,
    T Function(YieldAllTodoState)? yieldAllTodo,
    T Function(AddTodoSuccess)? addTodo,
    T Function(UpdateTodoState)? updateTodo,
    T Function(MarkTodoState)? markAsDone,
    T Function(FilterTodoState)? filterAll,
    T Function(OpenAddTodoDialogState)? openAddTodoDialog,
    T Function(DiscardTodoDialogState)? discardTodo,
    T Function(OpenEditTodoDialogState)? openEditTodoDialog,
    T Function(ShowTodoDetailsState)? todoDetails,
  }) {
    if (this is TodoLoading) {
      return loading?.call(this as TodoLoading);
    } else if (this is TodoProcessing) {
      return processing?.call(this as TodoProcessing);
    } else if (this is TodoFailure) {
      return error?.call(this as TodoFailure);
    } else if (this is TodoEmpty) {
      return empty?.call(this as TodoEmpty);
    } else if (this is RemoveTodoState) {
      return remove?.call(this as RemoveTodoState);
    } else if (this is RemoveAllTodoState) {
      return removeAll?.call(this as RemoveAllTodoState);
    } else if (this is GetTodoState) {
      return getById?.call(this as GetTodoState);
    } else if (this is YieldAllTodoState) {
      return yieldAllTodo?.call(this as YieldAllTodoState);
    } else if (this is AddTodoSuccess) {
      return addTodo?.call(this as AddTodoSuccess);
    } else if (this is UpdateTodoState) {
      return updateTodo?.call(this as UpdateTodoState);
    } else if (this is MarkTodoState) {
      return markAsDone?.call(this as MarkTodoState);
    } else if (this is FilterTodoState) {
      return filterAll?.call(this as FilterTodoState);
    } else if (this is OpenAddTodoDialogState) {
      return openAddTodoDialog?.call(this as OpenAddTodoDialogState);
    } else if (this is DiscardTodoDialogState) {
      return discardTodo?.call(this as DiscardTodoDialogState);
    } else if (this is OpenEditTodoDialogState) {
      return openEditTodoDialog?.call(this as OpenEditTodoDialogState);
    } else if (this is ShowTodoDetailsState) {
      return todoDetails?.call(this as ShowTodoDetailsState);
    } else {
      return null;
    }
  }
}
